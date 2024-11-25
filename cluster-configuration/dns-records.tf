resource "powerdns_record" "ingress" {
  zone    = "${var.dns_domain}."
  name    = "${var.cluster_name}-ingress.${var.dns_domain}."
  type    = "A"
  ttl     = var.dns_record_ttl
  records = [data.kubernetes_service.ingress-nginx.status.0.load_balancer.0.ingress.0.ip]
}
resource "powerdns_record" "argocd" {
  zone    = "${var.dns_domain}."
  name    = "${var.cluster_name}-argocd.${var.dns_domain}."
  type    = "A"
  ttl     = var.dns_record_ttl
  records = [data.kubernetes_service.argocd-server.status.0.load_balancer.0.ingress.0.ip]
}
