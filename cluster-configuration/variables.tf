variable "cluster_ready" {
  type        = bool
  description = "Initial cluster state"
  default     = false
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
