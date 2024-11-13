# S3 backend not working in backend configuration (
# variable "talos_bucket" {
#   type        = string
#   description = "Bucket path for backend configuration"
#   default     = ""
# }

# HashiCorp Vault
variable "vault_addr" {
  type        = string
  description = "Vault address"
  default     = "https://vault.lenta.tech:8200/"
}
#Powerdns Fetched from vault
##################
# variable "powerdns_api_key" {
#   type        = string
#   description = "powerdns_api_key"
#   default     = ""
# }

variable "powerdns_server_url" {
  type        = string
  description = "powerdns_server_url"
  default     = ""
}

variable "dns_record_ttl" {
  type        = number
  description = "dns record ttl"
  default     = 300
}

# vSphere connection Fetched from vault
##########################
# variable "vsphere_user" {
#   type        = string
#   description = "vSphere user name"
#   default     = ""
# }
#
# variable "vsphere_password" {
#   type        = string
#   description = "vSphere user password"
#   #default = ""
# }

variable "vsphere_server" {
  type        = string
  description = "vcenter IP or FQDN"
  #default     = ""
}

variable "vsphere_datacenter" {
  type        = string
  description = "vSphere datacenter name"
  default     = "Orange"
}

variable "vsphere_datastore" {
  type        = string
  description = "vSphere datastore name"
}

variable "vm_cluster" {
  type        = string
  description = "vSphere vm cluster name"
}

variable "vm_network" {
  type        = string
  description = "vSphere vm network name"
}

variable "vm_template_name" {
  type        = string
  description = "Template name to create vm from"
  default     = "ubuntu-template"
}

variable "vm_cluster_folder" {
  type        = string
  description = "Folder for vms on vSphere"
  default     = "kubespray-cluster"
}

variable "vsphere_datastores" {
  type    = map(any)
  default = {}
}

#Network
##########################
variable "vm_netmask" {
  type    = number
  default = 23
}

variable "vm_gateway" {
  type = string
}

variable "vm_dns" {
  type    = list(any)
  default = ["10.50.1.1", "10.50.1.2"]
}

#Variables for master nodes
##########################
variable "vm_controlplane_nodes" {
  type = map(any)
}

#Variables for worker nodes
##########################
variable "vm_worker_nodes" {
  type    = map(any)
  default = {}
}

variable "resource_pool" {
  type        = string
  description = "resource pool"
}

variable "vm_domain" {
  type        = string
  description = "k8s cluster domain"
}

#Variables for custom worker nodes
##########################
variable "vm_custom_worker_node" {
  type    = map(any)
  default = {}
}

variable "external_worker_node" {
  type    = map(any)
  default = {}
}


# TALOS
variable "vm_vip" {
  description = "VIP Ip"
  type        = string
}
variable "vm_vip_hostname" {
  description = "VIP hostname"
  type        = string
}

variable "vm_routes" {
  description = "List of maps for network routes"
  type = list(object({
    network = string
    gateway = string
  }))
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
  default     = "talos-terraform"
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
  default     = ""
}
