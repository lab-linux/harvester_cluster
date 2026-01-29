# Rancher options
rancher_url = "https://rancher.lab-linux.com"

# Harvester options
harvester_cluster_name      = "lab01"
harvester_namespace         = "test"
harvester_project_name      = "gologic"
harvester_network_namespace = "gologic-shared"
harvester_network_name      = "shared"

# Cluster options
cluster_name = "test"
node_pools = {
  masters = {
    count        = 1
    cpu_count    = 2
    memory_size  = 4
    os_disk_size = 40
    image_name   = "iris-ubuntu22.04"
    roles        = ["etcd", "controlplane", "worker"]
  }
}

test_ingress   = false
ingress_prefix = "test"
ingress_domain = "go.lab-linux.com"

# Specific hosting env options
root_ca_cert_path         = "files/private_ca.crt" #Useful for mirror below
container_registry_mirror = "https://harbor.tools.mgt"
container_registries = {
  #rewrite harbor project = hostname
  docker = "docker.io"
  k8s    = "registry.k8s.io"
  ghcr   = "ghcr.io"
  quay   = "quay.io"
  suse   = "registry.suse.com"
  gitlab = "registry.gitlab.com"
}