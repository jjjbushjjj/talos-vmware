data "vault_generic_secret" "talos" {
  path = "cicd/talos"
}

data "vault_generic_secret" "lenta-tech-ssl-certs" {
  path = "certificates/*-lenta.tech"
}

data "kubernetes_service" "ingress-nginx" {
  depends_on = [kubernetes_service.ingress-nginx-controller]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "kubernetes_service" "argocd-server" {
  depends_on = [kustomization_resource.argocd]
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}
