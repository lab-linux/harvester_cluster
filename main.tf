data "rancher2_cluster" "harvester" {
  name = var.harvester_cluster_name
}

resource "rancher2_cloud_credential" "harvester" {
  name = "${data.rancher2_cluster.harvester.name}-${split(":", var.rancher_token)[0]}"
  harvester_credential_config {
    cluster_id         = data.rancher2_cluster.harvester.id
    cluster_type       = "imported"
    kubeconfig_content = data.rancher2_cluster.harvester.kube_config
  }

  lifecycle {
    ignore_changes = [harvester_credential_config]
  }
}

# Fix for getting machine selector secret
data "http" "harvester-kubeconfig" {
  depends_on = [rancher2_cloud_credential.harvester]

  url    = "${var.rancher_url}/k8s/clusters/${data.rancher2_cluster.harvester.id}/v1/harvester/kubeconfig"
  method = "POST"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode(var.rancher_token)}"
  }

  request_body = jsonencode({
    clusterRoleName    = "harvesterhci.io:cloudprovider"
    namespace          = var.harvester_namespace
    serviceAccountName = var.cluster_name
  })

  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "rancher2_project" "this" {
  cluster_id = data.rancher2_cluster.harvester.id
  name       = var.harvester_project_name
}

resource "rancher2_namespace" "this" {
  name       = var.harvester_namespace
  project_id = data.rancher2_project.this.id
}

resource "rancher2_machine_config_v2" "this" {
  for_each = var.node_pools

  generate_name = "${var.cluster_name}-harvester-${each.key}"

  harvester_config {
    vm_namespace         = rancher2_namespace.this.name
    cpu_count            = each.value.cpu_count
    memory_size          = each.value.memory_size
    reserved_memory_size = "-1"
    disk_info            = <<-EOF
      {
          "disks": [{
              "imageName": "${var.harvester_image_namespace}/${each.value.image_name}",
              "size": ${each.value.os_disk_size},
              "bootOrder": 1
          }]
      }
    EOF
    network_info         = <<-EOF
      {
          "interfaces": [{
              "networkName": "${var.harvester_network_namespace}/${var.harvester_network_name}"
          }]
      }
    EOF
    ssh_user             = var.prov_user
    user_data = base64encode(templatefile(var.vm_user_data_tmpl_file, {
      prov_user             = var.prov_user
      prov_user_ssh_pub_key = file(pathexpand(var.prov_user_ssh_pub_key))
      root_ca_cert          = try(indent(3, file(var.root_ca_cert_path)), "")
      proxy_host            = var.proxy_host
    }))
    network_data = var.vm_network_data != null ? base64encode(var.vm_network_data) : null
  }
}

resource "rancher2_cluster_v2" "this" {
  name = var.cluster_name

  kubernetes_version           = var.kubernetes_version
  cloud_credential_secret_name = rancher2_cloud_credential.harvester.id

  rke_config {

    dynamic "machine_pools" {
      for_each = var.node_pools

      content {
        name                = machine_pools.key
        drain_before_delete = true
        control_plane_role  = contains(machine_pools.value.roles, "controlplane")
        etcd_role           = contains(machine_pools.value.roles, "etcd")
        worker_role         = contains(machine_pools.value.roles, "worker")
        quantity            = machine_pools.value.count
        machine_config {
          kind = rancher2_machine_config_v2.this[machine_pools.key].kind
          name = rancher2_machine_config_v2.this[machine_pools.key].name
        }
      }
    }

    # NGINX: https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
    chart_values = <<-EOT
      harvester-cloud-provider:
        cloudConfigPath: /var/lib/rancher/rke2/etc/config-files/cloud-provider-config
        global:
          cattle:
            clusterName: ${var.cluster_name}
      rke2-calico: {}
      rke2-ingress-nginx:
        controller:
          ingressClassResource:
            default: true
          service:
            enabled: true
            type: LoadBalancer
    EOT

    machine_selector_config {
      config = <<-YAML
        cloud-provider-config: ${yamlencode(replace(trimsuffix(trimprefix(data.http.harvester-kubeconfig.response_body, "\""), "\""), "\\n", "\n"))}
        cloud-provider-name: harvester
        protect-kernel-defaults: false
      YAML
    }

    machine_global_config = <<-EOF
      cni: calico
      disable-kube-proxy: false
      etcd-expose-metrics: false
    EOF

    registries {
      dynamic "mirrors" {
        for_each = var.container_registry_mirror != "" ? var.container_registries : {}

        content {
          hostname  = mirrors.value
          endpoints = [var.container_registry_mirror]
          rewrites = {
            "(.*)" = "${mirrors.key}/$1"
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [rke_config[0].machine_selector_config[0].config]
  }
}

resource "rancher2_cluster_sync" "this" {
  cluster_id = rancher2_cluster_v2.this.cluster_v1_id

  state_confirm = 6
}
