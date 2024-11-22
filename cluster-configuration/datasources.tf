data "vault_generic_secret" "talos" {
  path = "cicd/talos"
}

data "vault_generic_secret" "lenta-tech-ssl-certs" {
  path = "certificates/*-lenta.tech"
}

data "kubernetes_service" "ingress-nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}
