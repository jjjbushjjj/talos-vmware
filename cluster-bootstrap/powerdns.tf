resource "powerdns_record" "nodes_records" {
  for_each = merge(var.vm_controlplane_nodes, var.vm_worker_nodes)
  zone     = "${var.vm_domain}."
  name     = "${each.value.vm_name}."
  type     = "A"
  ttl      = var.dns_record_ttl
  records  = [each.value.ipv4_address]
}

resource "powerdns_record" "vip_record" {
  zone    = "${var.vm_domain}."
  name    = "${var.vm_vip_hostname}."
  type    = "A"
  ttl     = var.dns_record_ttl
  records = [var.vm_vip]
}

