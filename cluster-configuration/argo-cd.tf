resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "argocd-server-tls" {
  depends_on = [
    kubernetes_namespace.argocd
  ]
  metadata {
    name      = "argocd-server-tls"
    namespace = "argocd"
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.key" = data.vault_generic_secret.lenta-tech-ssl-certs.data["key"]
    "tls.crt" = data.vault_generic_secret.lenta-tech-ssl-certs.data["body"]
  }
}

data "kustomization_build" "argocd" {
  path = "manifests/argo-cd"
}

resource "kustomization_resource" "argocd" {
  for_each   = data.kustomization_build.argocd.manifests
  manifest   = each.value
  depends_on = [kubernetes_secret.argocd-server-tls]
}
