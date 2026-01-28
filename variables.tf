variable "prov_user" {
  type        = string
  description = "VM user to create for ssh Rancher operations"
  default     = "ubuntu"
}

variable "prov_user_ssh_pub_key" {
  type        = string
  description = "VM user ssh public key file path to inject under prov_user account"
  default     = "~/.ssh/id_rsa.pub"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name to create"
}

variable "ingress_domain" {
  type        = string
  description = "Ingress domain name suffix"
  default     = ""
}

variable "container_registry_mirror" {
  type        = string
  description = "Container registry mirror"
  default     = ""
}

variable "container_registries" {
  type        = map(string)
  default     = {}
  description = "Container registries that need to be pulled from mirror"
}

variable "vm_user_data_tmpl_file" {
  type        = string
  description = "Cloud init user-data template file"
  default     = "cloud-inits/ubuntu.tftpl"
}

variable "vm_network_data" {
  type        = string
  description = "Cloud init network-data"
  default     = null
}

variable "harvester_network_namespace" {
  type        = string
  description = "Harvester VM network namespace"
}

variable "harvester_network_name" {
  type        = string
  description = "Harvester network name to use for VM"
}

variable "harvester_project_name" {
  type        = string
  description = "Harvester operating project name"
}

variable "harvester_namespace" {
  type        = string
  description = "Harvester operating namespace"
}

variable "harvester_image_name" {
  type        = string
  description = "Harvester cloud image name"
}

variable "kubernetes_version" {
  type        = string
  description = "Cluster's Kubernetes version"
  default     = "v1.34.2+rke2r1"
}

variable "harvester_image_namespace" {
  type        = string
  default     = "harvester-public"
  description = "Where the VM cloud image would be used from"
}

variable "rancher_url" {
  type        = string
  description = "Rancher URL"
}

variable "rancher_token" {
  type        = string
  sensitive   = true
  description = "Rancher Token"
}

variable "harvester_cluster_name" {
  type        = string
  description = "Harvester cluster name"
}

variable "node_pools" {
  default     = {}
  description = "Node pools attributes"
}

variable "test_ingress" {
  type        = bool
  description = "Deploy demo app with ingress"
  default     = false
}

variable "proxy_host" {
  type        = string
  description = "Proxy host with port"
  default     = ""
}

variable "root_ca_cert_path" {
  type        = string
  description = "Extra CA root certificate file path to add to the VM"
  default     = ""
}