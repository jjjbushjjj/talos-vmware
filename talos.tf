resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  for_each         = var.vm_controlplane_nodes
  config_patches = [
    templatefile("${path.module}/templates/control_nodes.yaml.tmpl", {
      hostname = each.value.hostname
      ip       = each.value.ipv4_address
      dns      = jsonencode(var.vm_dns)
      netmask  = var.vm_netmask
      routes   = jsonencode(var.vm_routes)
      vip      = var.vm_vip
    }),
    # file("${path.module}/files/cp-scheduling.yaml"),
    file("${path.module}/patches/disable-external-service-registry.yaml"),
    file("${path.module}/patches/disable-cni.yaml"),
    file("${path.module}/patches/cilium-install-job.yaml"),
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  for_each         = var.vm_worker_nodes
  config_patches = [
    templatefile("${path.module}/templates/worker_nodes.yaml.tmpl", {
      hostname = each.value.hostname
      ip       = each.value.ipv4_address
      dns      = jsonencode(var.vm_dns)
      netmask  = var.vm_netmask
      routes   = jsonencode(var.vm_routes)
    }),
    file("${path.module}/patches/disable-external-service-registry.yaml"),
    file("${path.module}/patches/disable-cni.yaml"),
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [vsphere_virtual_machine.controlplane]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.vm_controlplane_nodes : v.ipv4_address][0]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.vm_controlplane_nodes : v.ipv4_address]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.vm_controlplane_nodes : v.ipv4_address][0]
}

# Wait for cluster to be fully functional. This used as dependency for kubectl resources
data "talos_cluster_health" "this" {
  depends_on           = [data.talos_machine_configuration.controlplane, data.talos_machine_configuration.worker]
  client_configuration = talos_machine_secrets.this.client_configuration
  # client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes = [for k, v in var.vm_controlplane_nodes : v.ipv4_address]
  worker_nodes        = [for k, v in var.vm_worker_nodes : v.ipv4_address]
  endpoints           = [for k, v in var.vm_controlplane_nodes : v.ipv4_address]
}

# Save talos and kubernetes configs to local files. Exlude them from git!!!
resource "local_file" "kubectl" {
  content         = resource.talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = "kubeconfig"
  file_permission = "0600"
}

resource "local_file" "talosctl" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = "talosconfig"
  file_permission = "0600"
}
