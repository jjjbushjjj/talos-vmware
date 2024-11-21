resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "kubernetes_service_account" "ingress-nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  automount_service_account_token = true
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0"
    }
    namespace = "ingress-nginx"
    name      = "ingress-nginx"
  }
}

resource "kubernetes_service_account" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  automount_service_account_token = true
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0"
    }
    namespace = "ingress-nginx"
    name      = "ingress-nginx-admission"
  }
}

resource "kubernetes_role" "ingress-nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups     = ["coordination.k8s.io"]
    resource_names = ["ingress-nginx-leader"]
    resources      = ["leases"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["list", "watch", "get"]
  }
}

resource "kubernetes_role" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "create"]
  }
}

resource "kubernetes_cluster_role" "ingress-nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx",
      "app.kubernetes.io/name"     = "ingress-nginx",
      "app.kubernetes.io/part-of"  = "ingress-nginx",
      "app.kubernetes.io/version"  = "1.12.0-beta.0",
    }
    name = "ingress-nginx"
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets", "namespaces"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingress/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["list", "watch", "get"]
  }
}

resource "kubernetes_cluster_role" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name = "ingress-nginx-admission"
  }
  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
    verbs      = ["get", "update"]
  }
}

resource "kubernetes_role_binding" "ingress-nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_role_binding" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "ingress-nginx-admission"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_cluster_role_binding" "ingress-nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx",
      "app.kubernetes.io/name"     = "ingress-nginx",
      "app.kubernetes.io/part-of"  = "ingress-nginx",
      "app.kubernetes.io/version"  = "1.12.0-beta.0",
    }
    name = "ingress-nginx"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_cluster_role_binding" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name = "ingress-nginx-admission"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "ingress-nginx-admission"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx-admission"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_config_map" "ingress-nginx-controller" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  data = {}
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

resource "kubernetes_service" "ingress-nginx-controller" {
  depends_on = [
    kubernetes_manifest.cilium-l2-announcement-policy,
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  spec {
    # This is important otherwise network don't work with cilium cni
    external_traffic_policy = "Cluster"
    ip_families             = ["IPv4"]
    ip_family_policy        = "SingleStack"
    port {
      app_protocol = "http"
      name         = "http"
      port         = 80
      protocol     = "TCP"
      target_port  = "http"
    }
    port {
      app_protocol = "https"
      name         = "https"
      port         = 443
      protocol     = "TCP"
      target_port  = "https"
    }
    selector = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "ingress-nginx-controller-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx",
      "app.kubernetes.io/name"     = "ingress-nginx",
      "app.kubernetes.io/part-of"  = "ingress-nginx",
      "app.kubernetes.io/version"  = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-controller-admission"
    namespace = "ingress-nginx"
  }
  spec {
    port {
      app_protocol = "https"
      name         = "https-webhook"
      port         = 443
      target_port  = "webhook"
    }
    selector = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "ingress-nginx-controller" {
  depends_on = [
    kubernetes_service.ingress-nginx-controller
  ]
  lifecycle {
    ignore_changes = [
      spec[0].template[0].metadata[0].annotations["kubectl.kubernetes.io/restartedAt"]
    ]
  }
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  spec {
    min_ready_seconds      = 0
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller",
        "app.kubernetes.io/instance"  = "ingress-nginx",
        "app.kubernetes.io/name"      = "ingress-nginx",
      }
    }
    strategy {
      rolling_update {
        max_unavailable = 1
      }
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "controller",
          "app.kubernetes.io/instance"  = "ingress-nginx",
          "app.kubernetes.io/name"      = "ingress-nginx",
          "app.kubernetes.io/part-of"   = "ingress-nginx",
          "app.kubernetes.io/version"   = "1.12.0-beta.0",
        }
      }
      spec {
        container {
          args = [
            "/nginx-ingress-controller",
            "--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller",
            "--election-id=ingress-nginx-leader",
            "--controller-class=k8s.io/ingress-nginx",
            "--ingress-class=nginx",
            "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller",
            "--validating-webhook=:8443",
            "--validating-webhook-certificate=/usr/local/certificates/cert",
            "--validating-webhook-key=/usr/local/certificates/key",
          ]
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }
          image             = "registry.k8s.io/ingress-nginx/controller:v1.12.0-beta.0@sha256:9724476b928967173d501040631b23ba07f47073999e80e34b120e8db5f234d5"
          image_pull_policy = "IfNotPresent"
          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }
          liveness_probe {
            failure_threshold = 5
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          name = "controller"
          port {
            container_port = 80
            name           = "http"
            protocol       = "TCP"
          }
          port {
            container_port = 443
            name           = "https"
            protocol       = "TCP"
          }
          port {
            container_port = 8443
            name           = "webhook"
            protocol       = "TCP"
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          resources {
            requests = {
              "cpu"    = "100m"
              "memory" = "90Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              add  = ["NET_BIND_SERVICE"]
              drop = ["ALL"]
            }
            read_only_root_filesystem = false
            run_as_group              = "82"
            run_as_non_root           = true
            run_as_user               = "101"
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
          volume_mount {
            mount_path = "/usr/local/certificates/"
            name       = "webhook-cert"
            read_only  = true
          }
        }
        dns_policy = "ClusterFirst"
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        service_account_name             = "ingress-nginx"
        termination_grace_period_seconds = 300
        volume {
          name = "webhook-cert"
          secret {
            secret_name = "ingress-nginx-admission"
          }
        }
      }
    }
  }
}

resource "kubernetes_job" "ingress-nginx-admission-create" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-admission-create"
    namespace = "ingress-nginx"
  }
  spec {
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "admission-webhook",
          "app.kubernetes.io/instance"  = "ingress-nginx",
          "app.kubernetes.io/name"      = "ingress-nginx",
          "app.kubernetes.io/part-of"   = "ingress-nginx",
          "app.kubernetes.io/version"   = "1.12.0-beta.0",
        }
        name = "ingress-nginx-admission-create"
      }
      spec {
        container {
          args = [
            "create",
            "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc",
            "--namespace=$(POD_NAMESPACE)",
            "--secret-name=ingress-nginx-admission",
          ]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.4@sha256:a9f03b34a3cbfbb26d103a14046ab2c5130a80c3d69d526ff8063d2b37b9fd3f"
          image_pull_policy = "IfNotPresent"
          name              = "create"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
            run_as_group              = "65532"
            run_as_non_root           = true
            run_as_user               = "65532"
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        restart_policy       = "OnFailure"
        service_account_name = "ingress-nginx-admission"
      }
    }
  }
}

resource "kubernetes_job" "ingress-nginx-admission-patch" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name      = "ingress-nginx-admission-patch"
    namespace = "ingress-nginx"
  }
  spec {
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "admission-webhook",
          "app.kubernetes.io/instance"  = "ingress-nginx",
          "app.kubernetes.io/name"      = "ingress-nginx",
          "app.kubernetes.io/part-of"   = "ingress-nginx",
          "app.kubernetes.io/version"   = "1.12.0-beta.0",
        }
        name = "ingress-nginx-admission-patch"
      }
      spec {
        container {
          args = [
            "patch",
            "--webhook-name=ingress-nginx-admission",
            "--namespace=$(POD_NAMESPACE)",
            "--patch-mutating=false",
            "--secret-name=ingress-nginx-admission",
            "--patch-failure-policy=Fail",
          ]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.4@sha256:a9f03b34a3cbfbb26d103a14046ab2c5130a80c3d69d526ff8063d2b37b9fd3f"
          image_pull_policy = "IfNotPresent"
          name              = "patch"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
            run_as_group              = "65532"
            run_as_non_root           = true
            run_as_user               = "65532"
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        restart_policy       = "OnFailure"
        service_account_name = "ingress-nginx-admission"
      }
    }
  }
}

resource "kubernetes_ingress_class" "nginx" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name = "nginx"
  }
  spec {
    controller = "k8s.io/ingress-nginx"
  }
}

resource "kubernetes_validating_webhook_configuration" "ingress-nginx-admission" {
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]
  lifecycle {
    ignore_changes = [
      webhook[0].client_config[0].ca_bundle
    ]
  }
  metadata {
    labels = {
      "app.kubernetes.io/component" = "admission-webhook",
      "app.kubernetes.io/instance"  = "ingress-nginx",
      "app.kubernetes.io/name"      = "ingress-nginx",
      "app.kubernetes.io/part-of"   = "ingress-nginx",
      "app.kubernetes.io/version"   = "1.12.0-beta.0",
    }
    name = "ingress-nginx-admission"
  }
  webhook {
    admission_review_versions = ["v1"]
    client_config {
      service {
        name      = "ingress-nginx-controller-admission"
        namespace = "ingress-nginx"
        path      = "/networking/v1/ingress"
        port      = 443
      }
    }
    failure_policy = "Fail"
    match_policy   = "Equivalent"
    name           = "validate.nginx.ingress.kubernetes.io"
    rule {
      api_groups   = ["networking.k8s.io"]
      api_versions = ["v1"]
      operations   = ["CREATE", "UPDATE"]
      resources    = ["ingresses"]
    }
    side_effects = "None"
  }
}
