resource "kubernetes_manifest" "cilium-ip-pool" {
  manifest = {
    "apiVersion" = "cilium.io/v2alpha1"
    "kind"       = "CiliumLoadBalancerIPPool"
    "metadata" = {
      "name" = "blue-pool"
    }
    "spec" = {
      "blocks" = [{
        "start" = var.cilium_ip_pool["start"],
        "stop"  = var.cilium_ip_pool["stop"]
      }]
    }
  }
}

resource "kubernetes_manifest" "cilium-l2-announcement-policy" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  manifest = {
    "apiVersion" = "cilium.io/v2alpha1"
    "kind"       = "CiliumL2AnnouncementPolicy"
    "metadata" = {
      "name" = "ingress-nginx"
    }
    "spec" = {
      "interfaces"      = ["eth+"]
      "externalIPs"     = "true"
      "loadBalancerIPs" = "true"
    }
  }
}
