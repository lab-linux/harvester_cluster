# harvester_cluster
Terraform/OpenTofu root module to create and manage a downstream cluster on Rancher using Harvester

## Requirements

- Access to a Rancher server with at minimum a project_member role to a Harvester cluster project
- A user created API token to operate on Rancher

## Optional features

- Proxy with private CA
- Container registry mirrors (recommended)
- Demo/Test application and ingress

## How-to

0. [Optional] If you want to manage as code, ideally fork this repo !
1. Login on Rancher and create an API key
2. Confirm with an admin the Harvester access and details (a project/namespace will be given)
3. Copy and update your own tfvars (see variables/examples.tfvars)
4. Create your cluster
5. [Optional] The Nginx Ingress controller will be provisionned with an internal LoadBalancer. If you wish north south (public) traffic, talk to an admin.
6. Enjoy !

# Terraform-Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.2 |
| <a name="requirement_http"></a> [http](#requirement\_http) | = 3.5.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | = 1.19.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | = 13.1.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.19.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 13.1.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.ingress_test_deploy](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19.0/docs/resources/manifest) | resource |
| [kubectl_manifest.ingress_test_ingress](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19.0/docs/resources/manifest) | resource |
| [kubectl_manifest.ingress_test_svc](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19.0/docs/resources/manifest) | resource |
| [rancher2_cloud_credential.harvester](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/resources/cloud_credential) | resource |
| [rancher2_cluster_sync.this](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/resources/cluster_sync) | resource |
| [rancher2_cluster_v2.this](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.this](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/resources/machine_config_v2) | resource |
| [rancher2_namespace.this](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/resources/namespace) | resource |
| [http_http.harvester-kubeconfig](https://registry.terraform.io/providers/hashicorp/http/3.5.0/docs/data-sources/http) | data source |
| [rancher2_cluster.harvester](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/data-sources/cluster) | data source |
| [rancher2_project.this](https://registry.terraform.io/providers/rancher/rancher2/13.1.4/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name to create | `string` | n/a | yes |
| <a name="input_container_registries"></a> [container\_registries](#input\_container\_registries) | Container registries that need to be pulled from mirror | `map(string)` | `{}` | no |
| <a name="input_container_registry_mirror"></a> [container\_registry\_mirror](#input\_container\_registry\_mirror) | Container registry mirror | `string` | `""` | no |
| <a name="input_harvester_cluster_name"></a> [harvester\_cluster\_name](#input\_harvester\_cluster\_name) | Harvester cluster name | `string` | n/a | yes |
| <a name="input_harvester_image_name"></a> [harvester\_image\_name](#input\_harvester\_image\_name) | Harvester cloud image name | `string` | n/a | yes |
| <a name="input_harvester_image_namespace"></a> [harvester\_image\_namespace](#input\_harvester\_image\_namespace) | Where the VM cloud image would be used from | `string` | `"harvester-public"` | no |
| <a name="input_harvester_namespace"></a> [harvester\_namespace](#input\_harvester\_namespace) | Harvester operating namespace | `string` | n/a | yes |
| <a name="input_harvester_network_name"></a> [harvester\_network\_name](#input\_harvester\_network\_name) | Harvester network name to use for VM | `string` | n/a | yes |
| <a name="input_harvester_network_namespace"></a> [harvester\_network\_namespace](#input\_harvester\_network\_namespace) | Harvester VM network namespace | `string` | n/a | yes |
| <a name="input_harvester_project_name"></a> [harvester\_project\_name](#input\_harvester\_project\_name) | Harvester operating project name | `string` | n/a | yes |
| <a name="input_ingress_domain"></a> [ingress\_domain](#input\_ingress\_domain) | Ingress domain name suffix | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Cluster's Kubernetes version | `string` | `"v1.34.2+rke2r1"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Node pools attributes | `map` | `{}` | no |
| <a name="input_prov_user"></a> [prov\_user](#input\_prov\_user) | VM user to create for ssh Rancher operations | `string` | `"ubuntu"` | no |
| <a name="input_prov_user_ssh_pub_key"></a> [prov\_user\_ssh\_pub\_key](#input\_prov\_user\_ssh\_pub\_key) | VM user ssh public key file path to inject under prov\_user account | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_proxy_host"></a> [proxy\_host](#input\_proxy\_host) | Proxy host with port | `string` | `""` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher Token | `string` | n/a | yes |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | Rancher URL | `string` | n/a | yes |
| <a name="input_root_ca_cert_path"></a> [root\_ca\_cert\_path](#input\_root\_ca\_cert\_path) | Extra CA root certificate file path to add to the VM | `string` | `""` | no |
| <a name="input_test_ingress"></a> [test\_ingress](#input\_test\_ingress) | Deploy demo app with ingress | `bool` | `false` | no |
| <a name="input_vm_network_data"></a> [vm\_network\_data](#input\_vm\_network\_data) | Cloud init network-data | `string` | `null` | no |
| <a name="input_vm_user_data_tmpl_file"></a> [vm\_user\_data\_tmpl\_file](#input\_vm\_user\_data\_tmpl\_file) | Cloud init user-data template file | `string` | `"cloud-inits/ubuntu.tftpl"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->