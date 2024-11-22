# Backend configuration for s3
# talos_bucket = "talos-mng"



# HashiCorp Vault
vault_addr = "https://vault.lenta.tech:8200"
# vSphere connection
# If you can't connect to vcenter from your local machine try to swap addresses below
# vsphere_server = "10.3.21.1"

vm_vip_hostname = "k8s-talos-mng.lenta.tech"

cilium_ip_pool = {
  start = "10.3.22.120"
  stop  = "10.3.22.130"
}

cluster_name        = "talos"
dns_domain          = "lenta.tech"
powerdns_server_url = "http://10.3.27.251:8081/"
