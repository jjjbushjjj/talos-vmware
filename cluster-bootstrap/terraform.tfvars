# Backend configuration for s3
# talos_bucket = "talos-mng"


# HashiCorp Vault
vault_addr = "https://vault.lenta.tech:8200"
# PowerDNS
powerdns_server_url = "http://10.3.27.251:8081/"
# vSphere connection
# If you can't connect to vcenter from your local machine try to swap addresses below
# vsphere_server = "10.3.21.1"
vsphere_server     = "vc.kube-prod.lenta.tech"
resource_pool      = "talos-k8s-mng"
vsphere_datacenter = "DC-LO"
vsphere_datastore  = "NetAppA700_2_Kudrovo_04_DS_Dev"
vm_cluster         = "CL-INFRA-HILO"
vm_cluster_folder  = "k8s/k8s-talos"
vm_domain          = "lenta.tech"
vm_network         = "DS-LO/vl302_DEV_10.3.\\[22-23\\]"
vm_gateway         = "10.3.23.254"
vm_netmask         = "23"
vm_dns             = ["10.3.27.251", "10.3.27.252"]

vm_template_name = "talos-v1.8.0"

vm_routes = [{
  network = "0.0.0.0/0"
  gateway = "10.3.23.254"
  },
  {
    network = "192.168.4.0/24"
    gateway = "10.3.23.253"
}]

vm_vip           = "10.3.22.100"
vm_vip_hostname  = "k8s-talos-mng.lenta.tech"
cluster_endpoint = "https://10.3.22.100:6443"

vm_controlplane_nodes = {
  "k8s-talos-mng-cp-01.lenta.tech" = {
    vm_name      = "k8s-talos-mng-cp-01.lenta.tech"
    hostname     = "k8s-talos-mng-cp-01"
    ipv4_address = "10.3.22.101"
    num_cpus     = 2
    memory       = 4096
    disk_size    = 10
  }
  "k8s-talos-mng-cp-02.lenta.tech" = {
    vm_name      = "k8s-talos-mng-cp-02.lenta.tech"
    hostname     = "k8s-talos-mng-cp-02"
    ipv4_address = "10.3.22.102"
    num_cpus     = 4
    memory       = 4096
    disk_size    = 10
  }
  "k8s-talos-mng-cp-03.lenta.tech" = {
    vm_name      = "k8s-talos-mng-cp-03.lenta.tech"
    hostname     = "k8s-talos-mng-cp-03"
    ipv4_address = "10.3.22.103"
    num_cpus     = 4
    memory       = 4096
    disk_size    = 10
  }
}
vm_worker_nodes = {
  "k8s-talos-mng-wrk-01.lenta.tech" = {
    vm_name      = "k8s-talos-mng-wrk-01.lenta.tech"
    hostname     = "k8s-talos-mng-wrk-01"
    ipv4_address = "10.3.22.104"
    num_cpus     = 4
    memory       = 4096
    disk_size    = 20
  }
  "k8s-talos-mng-wrk-02.lenta.tech" = {
    vm_name      = "k8s-talos-mng-wrk-02.lenta.tech"
    hostname     = "k8s-talos-mng-wrk-02"
    ipv4_address = "10.3.22.105"
    num_cpus     = 4
    memory       = 4096
    disk_size    = 20
  }
  "k8s-talos-mng-wrk-03.lenta.tech" = {
    vm_name      = "k8s-talos-mng-wrk-03.lenta.tech"
    hostname     = "k8s-talos-mng-wrk-03"
    ipv4_address = "10.3.22.106"
    num_cpus     = 4
    memory       = 4096
    disk_size    = 20
  }
}
