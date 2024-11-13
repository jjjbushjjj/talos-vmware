data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vm_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.resource_pool
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

resource "vsphere_folder" "folder" {
  path          = var.vm_cluster_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Deploy a VM from OVF in Content Library
# CONTROLPLANE NODES
resource "vsphere_virtual_machine" "controlplane" {
  for_each                    = var.vm_controlplane_nodes
  name                        = each.value.vm_name
  datastore_id                = data.vsphere_datastore.datastore.id
  resource_pool_id            = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  folder                      = vsphere_folder.folder.path
  wait_for_guest_net_routable = false
  wait_for_guest_net_timeout  = 0
  wait_for_guest_ip_timeout   = 0
  enable_disk_uuid            = true # NB the VM must have disk.EnableUUID=1 for, e.g., k8s persistent storage. folder           = var.vm_cluster_folder
  num_cpus                    = each.value.num_cpus
  memory                      = each.value.memory

  disk {
    label           = "disk0"
    size            = each.value.disk_size
    controller_type = "scsi"
  }

  clone {
    template_uuid = data.vsphere_content_library_item.talos.id
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  extra_config = {
    "guestinfo.talos.config" = base64encode(data.talos_machine_configuration.controlplane[each.key].machine_configuration)
  }
  lifecycle {
    # TODO why is terraform plan trying to modify these?
    ignore_changes = [
      ept_rvi_mode,
      hv_mode,
    ]
  }
}

# WORKER NODES
resource "vsphere_virtual_machine" "worker" {
  for_each                    = var.vm_worker_nodes
  name                        = each.value.vm_name
  datastore_id                = data.vsphere_datastore.datastore.id
  resource_pool_id            = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  folder                      = vsphere_folder.folder.path
  wait_for_guest_net_routable = false
  wait_for_guest_net_timeout  = 0
  wait_for_guest_ip_timeout   = 0
  enable_disk_uuid            = true # NB the VM must have disk.EnableUUID=1 for, e.g., k8s persistent storage. folder           = var.vm_cluster_folder
  num_cpus                    = each.value.num_cpus
  memory                      = each.value.memory

  disk {
    label           = "disk0"
    size            = each.value.disk_size
    controller_type = "scsi"
  }

  clone {
    template_uuid = data.vsphere_content_library_item.talos.id
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  extra_config = {
    "guestinfo.talos.config" = base64encode(data.talos_machine_configuration.worker[each.key].machine_configuration)
  }
  lifecycle {
    # TODO why is terraform plan trying to modify these?
    ignore_changes = [
      ept_rvi_mode,
      hv_mode,
    ]
  }
}

