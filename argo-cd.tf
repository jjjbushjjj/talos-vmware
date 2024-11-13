# TODO Add actual installation here
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [data.talos_cluster_health.this]
}
