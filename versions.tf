terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "= 13.1.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.19.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "= 3.5.0"
    }
  }
  required_version = ">= 1.6.2"
}
