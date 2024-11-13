# Image id form content library
output "image_id" {
  value = data.vsphere_content_library_item.talos
}

output "nodes_configs_controlplane" {
  value     = values(data.talos_machine_configuration.controlplane)[*].machine_configuration
  sensitive = true
}

output "nodes_configs_worker" {
  value     = values(data.talos_machine_configuration.worker)[*].machine_configuration
  sensitive = true
}

output "kubectl_config" {
  value     = resource.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "talosctl_config" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}
