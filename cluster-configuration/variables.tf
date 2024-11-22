variable "cluster_name" {
  type        = string
  description = "Cluster name used as prefix to name resources"
  default     = ""
}

variable "dns_domain" {
  type        = string
  description = "Dns domain"
  default     = "lenta.tech"
}

# HashiCorp Vault
variable "vault_addr" {
  type        = string
  description = "Vault address"
  default     = "https://vault.lenta.tech:8200/"
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

variable "vsphere_datacenter" {
  type        = string
  description = "vSphere datacenter name"
  default     = "Orange"
}

variable "cilium_ip_pool" {
  description = "IPPool for Cilium"
  type        = map(any)
  default     = {}
}

variable "vm_vip_hostname" {
  description = "VIP hostname"
  type        = string
}

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
