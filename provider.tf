provider "kubectl" {
  host             = yamldecode(rancher2_cluster_v2.this.kube_config).clusters[0].cluster.server
  token            = yamldecode(rancher2_cluster_v2.this.kube_config).users[0].user.token
  load_config_file = false
}

provider "rancher2" {
  api_url   = var.rancher_url
  token_key = var.rancher_token
}
