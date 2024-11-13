data "vsphere_datacenter" "datacenter_a" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "talos" {
  name          = "NetAppA700_2_Kudrovo_03_k8s_mng"
  datacenter_id = data.vsphere_datacenter.datacenter_a.id
}

resource "vsphere_content_library" "talos" {
  name            = "talos"
  storage_backing = [data.vsphere_datastore.talos.id]
}

data "vsphere_content_library_item" "talos" {
  name       = var.vm_template_name
  type       = "ovf"
  library_id = resource.vsphere_content_library.talos.id
}


# Not working over proxy
resource "vsphere_content_library_item" "content_library_item" {
  name        = "talos-v1.8.0"
  description = "Talos linux for vmware"
  # file_url    = "https://factory.talos.dev/image/903b2da78f99adef03cbbd4df6714563823f63218508800751560d3bc3557e40/v1.8.0/vmware-amd64.ova"
  library_id = resource.vsphere_content_library.talos.id
}
