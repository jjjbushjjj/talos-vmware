resource "kubernetes_namespace" "vmware-system-csi" {
  metadata {
    name = "vmware-system-csi"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
  depends_on = [data.talos_cluster_health.this]
}

resource "kubernetes_secret" "vsphere-config-secret" {
  wait_for_service_account_token = true
  metadata {
    name      = "vsphere-config-secret"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  data = {
    "csi-vsphere.conf" = "${templatefile("${path.module}/templates/csi-vsphere.conf.tmpl",
      { vsphere_user     = data.vault_generic_secret.talos.data["vsphere_user"],
        vsphere_password = data.vault_generic_secret.talos.data["vsphere_password"]
    })}"
  }
}

resource "kubernetes_service_account" "vsphere-csi-controller" {
  automount_service_account_token = true
  metadata {
    name      = "vsphere-csi-controller"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "vsphere-csi-cluster-role" {
  metadata {
    name = "vsphere-csi-controller-role"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes", "pods"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "create"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims/status"]
    verbs      = ["patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "watch", "list", "delete", "update", "create"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments"]
    verbs      = ["get", "list", "watch", "patch"]
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["triggercsifullsyncs"]
    verbs      = ["create", "get", "update", "watch", "list"]
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["cnsvspherevolumemigrations"]
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["cnsvolumeinfoes"]
    verbs      = ["create", "get", "list", "watch", "delete"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "create", "update"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments/status"]
    verbs      = ["patch"]
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["cnsvolumeoperationrequests"]
    verbs      = ["create", "get", "list", "update", "delete"]
  }
  rule {
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshots"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshotclasses"]
    verbs      = ["watch", "get", "list"]
  }
  rule {
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshotcontents"]
    verbs      = ["create", "get", "list", "watch", "update", "delete", "patch"]
  }
  rule {
    api_groups = ["snapshot.storage.k8s.io"]
    resources  = ["volumesnapshotcontents/status"]
    verbs      = ["update", "patch"]
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["csinodetopologies"]
    verbs      = ["get", "update", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "vsphere-csi-controller-binding" {
  metadata {
    name = "vsphere-csi-controller-binding"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vsphere-csi-controller"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "vsphere-csi-controller-role"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_service_account" "vsphere-csi-node" {
  automount_service_account_token = true
  metadata {
    name      = "vsphere-csi-node"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "vsphere-csi-node-clister-role" {
  metadata {
    name = "vsphere-csi-node-cluster-role"
  }
  rule {
    api_groups = ["cns.vmware.com"]
    resources  = ["csinodetopologies"]
    verbs      = ["create", "watch", "get", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "vsphere-csi-node-cluster-role-binding" {
  metadata {
    name = "vsphere-csi-node-cluster-role-binding"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vsphere-csi-node"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "vsphere-csi-node-cluster-role"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "vsphere-csi-node-role" {
  metadata {
    name      = "vsphere-csi-node-role"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "vsphere-csi-node-binding" {
  metadata {
    name      = "vsphere-csi-node-binding"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vsphere-csi-node"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  role_ref {
    kind      = "Role"
    name      = "vsphere-csi-node-role"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_config_map" "internal-feature-states-csi-vsphere-vmware-com" {
  metadata {
    name      = "internal-feature-states.csi.vsphere.vmware.com"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  data = {
    "csi-migration"                     = "true"
    "csi-auth-check"                    = "true"
    "online-volume-extend"              = "true"
    "trigger-csi-fullsync"              = "false"
    "async-query-volume"                = "true"
    "block-volume-snapshot"             = "true"
    "csi-windows-support"               = "false"
    "use-csinode-id"                    = "true"
    "list-volumes"                      = "true"
    "pv-to-backingdiskobjectid-mapping" = "false"
    "cnsmgr-suspend-create-volume"      = "true"
    "topology-preferential-datastores"  = "true"
    "max-pvscsi-targets-per-vm"         = "true"
    "multi-vcenter-csi-topology"        = "true"
    "csi-internal-generated-cluster-id" = "true"
    "listview-tasks"                    = "false"
  }
}

resource "kubernetes_service" "vsphere-csi-controller" {
  wait_for_load_balancer = false
  metadata {
    name      = "vsphere-csi-controller"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
    labels = {
      "app" = "vsphere-csi-controller"
    }
  }
  spec {
    port {
      name = "ctlr"
      port = "2112"
    }
    port {
      name        = "syncer"
      port        = "2113"
      target_port = "2113"
      protocol    = "TCP"
    }
    selector = {
      "app" = "vsphere-csi-controller"
    }
  }
}

resource "kubernetes_deployment" "vsphere-csi-controller" {
  wait_for_rollout = false
  metadata {
    name        = "vsphere-csi-controller"
    namespace   = kubernetes_namespace.vmware-system-csi.metadata[0].name
    annotations = {}
    labels      = {}
  }
  spec {
    replicas = "3"
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "0"
        max_unavailable = "1"
      }
    }
    selector {
      match_labels = {
        "app" = "vsphere-csi-controller"
      }
    }
    template {
      metadata {
        labels = {
          "app"  = "vsphere-csi-controller"
          "role" = "vsphere-csi"
        }
      }
      spec {
        automount_service_account_token = true
        enable_service_links            = false
        priority_class_name             = "system-cluster-critical"
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["vsphere-csi-controller"]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }
        service_account_name = "vsphere-csi-controller"
        node_selector = {
          "node-role.kubernetes.io/control-plane" = ""
        }
        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        dns_policy = "Default"
        container {
          name  = "csi-attacher"
          image = "k8s.gcr.io/sig-storage/csi-attacher:v4.2.0"
          args = [
            "--v=4",
            "--timeout=300s",
            "--csi-address=$(ADDRESS)",
            "--leader-election",
            "--leader-election-lease-duration=120s",
            "--leader-election-renew-deadline=60s",
            "--leader-election-retry-period=30s",
            "--kube-api-qps=100",
            "--kube-api-burst=100"
          ]
          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        container {
          name  = "csi-resizer"
          image = "k8s.gcr.io/sig-storage/csi-resizer:v1.7.0"
          args = [
            "--v=4",
            "--timeout=300s",
            "--handle-volume-inuse-error=false",
            "--csi-address=$(ADDRESS)",
            "--kube-api-qps=100",
            "--kube-api-burst=100",
            "--leader-election",
            "--leader-election-lease-duration=120s",
            "--leader-election-renew-deadline=60s",
            "--leader-election-retry-period=30s",
          ]
          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        container {
          name  = "vsphere-csi-controller"
          image = "registry.k8s.io/csi-vsphere/driver:v3.3.1"
          args = [
            "--fss-name=internal-feature-states.csi.vsphere.vmware.com",
            "--fss-namespace=$(CSI_NAMESPACE)"
          ]
          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///csi/csi.sock"
          }
          env {
            name  = "X_CSI_MODE"
            value = "controller"
          }
          env {
            name  = "X_CSI_SPEC_DISABLE_LEN_CHECK"
            value = "true"
          }
          env {
            name  = "X_CSI_SERIAL_VOL_ACCESS_TIMEOUT"
            value = "3m"
          }
          env {
            name  = "VSPHERE_CSI_CONFIG"
            value = "/etc/cloud/csi-vsphere.conf"
          }
          env {
            name  = "LOGGER_LEVEL"
            value = "PRODUCTION"
          }
          env {
            name  = "INCLUSTER_CLIENT_QPS"
            value = "100"
          }
          env {
            name  = "INCLUSTER_CLIENT_BURST"
            value = "100"
          }
          env {
            name = "CSI_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          volume_mount {
            mount_path = "/etc/cloud"
            name       = "vsphere-config-volume"
            read_only  = true
          }
          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
          port {
            name           = "healthz"
            container_port = "9808"
            protocol       = "TCP"
          }
          port {
            name           = "prometheus"
            container_port = "2112"
            protocol       = "TCP"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }
            initial_delay_seconds = "30"
            timeout_seconds       = "10"
            period_seconds        = "180"
            failure_threshold     = "3"
          }
        }
        container {
          name  = "liveness-probe"
          image = "k8s.gcr.io/sig-storage/livenessprobe:v2.9.0"
          args = [
            "--v=4",
            "--csi-address=/csi/csi.sock"
          ]
          volume_mount {
            name       = "socket-dir"
            mount_path = "/csi"
          }
        }
        container {
          name  = "vsphere-syncer"
          image = "registry.k8s.io/csi-vsphere/syncer:v3.3.1"
          args = [
            "--leader-election",
            "--leader-election-lease-duration=120s",
            "--leader-election-renew-deadline=60s",
            "--leader-election-retry-period=30s",
            "--fss-name=internal-feature-states.csi.vsphere.vmware.com",
            "--fss-namespace=$(CSI_NAMESPACE)"
          ]
          port {
            container_port = "2113"
            name           = "prometheus"
            protocol       = "TCP"
          }
          env {
            name  = "FULL_SYNC_INTERVAL_MINUTES"
            value = "30"
          }
          env {
            name  = "VSPHERE_CSI_CONFIG"
            value = "/etc/cloud/csi-vsphere.conf"
          }
          env {
            name  = "LOGGER_LEVEL"
            value = "PRODUCTION"
          }
          env {
            name  = "INCLUSTER_CLIENT_QPS"
            value = "100"
          }
          env {
            name  = "INCLUSTER_CLIENT_BURST"
            value = "100"
          }
          env {
            name  = "GODEBUG"
            value = "x509sha1=1"
          }
          env {
            name = "CSI_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          volume_mount {
            mount_path = "/etc/cloud"
            name       = "vsphere-config-volume"
            read_only  = true
          }
        }
        container {
          name  = "csi-provisioner"
          image = "k8s.gcr.io/sig-storage/csi-provisioner:v3.4.0"
          args = [
            "--v=4",
            "--timeout=300s",
            "--csi-address=$(ADDRESS)",
            "--kube-api-qps=100",
            "--kube-api-burst=100",
            "--leader-election",
            "--leader-election-lease-duration=120s",
            "--leader-election-renew-deadline=60s",
            "--leader-election-retry-period=30s",
            "--default-fstype=ext4",
          ]
          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        container {
          name  = "csi-snapshotter"
          image = "k8s.gcr.io/sig-storage/csi-snapshotter:v6.2.1"
          args = [
            "--v=4",
            "--kube-api-qps=100",
            "--kube-api-burst=100",
            "--timeout=300s",
            "--csi-address=$(ADDRESS)",
            "--leader-election",
            "--leader-election-lease-duration=120s",
            "--leader-election-renew-deadline=60s",
            "--leader-election-retry-period=30s",
          ]
          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }
        volume {
          name = "vsphere-config-volume"
          secret {
            secret_name = "vsphere-config-secret"
          }
        }
        volume {
          name = "socket-dir"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_daemonset" "vsphere-csi-node" {
  wait_for_rollout = false
  metadata {
    name      = "vsphere-csi-node"
    namespace = kubernetes_namespace.vmware-system-csi.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        "app" = "vsphere-csi-node"
      }
    }
    template {
      metadata {
        labels = {
          "app"  = "vsphere-csi-node"
          "role" = "vsphere-csi"
        }
      }
      spec {
        automount_service_account_token = true
        enable_service_links            = false
        priority_class_name             = "system-node-critical"
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        service_account_name = "vsphere-csi-node"
        host_network         = true
        dns_policy           = "ClusterFirstWithHostNet"
        container {
          name  = "node-driver-registrar"
          image = "k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.7.0"
          args = [
            "--v=5",
            "--csi-address=$(ADDRESS)",
            "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
          ]
          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }
          env {
            name  = "DRIVER_REG_SOCK_PATH"
            value = "/var/lib/kubelet/plugins/csi.vsphere.vmware.com/csi.sock"
          }
          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }
          volume_mount {
            name       = "registration-dir"
            mount_path = "/registration"
          }
          liveness_probe {
            exec {
              command = [
                "/csi-node-driver-registrar",
                "--kubelet-registration-path=/var/lib/kubelet/plugins/csi.vsphere.vmware.com/csi.sock",
                "--mode=kubelet-registration-probe"
              ]
            }
            initial_delay_seconds = "3"
          }
        }
        container {
          name  = "vsphere-csi-node"
          image = "registry.k8s.io/csi-vsphere/driver:v3.3.1"
          args = [
            "--fss-name=internal-feature-states.csi.vsphere.vmware.com",
            "--fss-namespace=$(CSI_NAMESPACE)"
          ]
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///csi/csi.sock"
          }
          env {
            name  = "MAX_VOLUMES_PER_NODE"
            value = "59"
          }
          env {
            name  = "X_CSI_MODE"
            value = "node"
          }
          env {
            name  = "X_CSI_SPEC_REQ_VALIDATION"
            value = "false"
          }
          env {
            name  = "X_CSI_SPEC_DISABLE_LEN_CHECK"
            value = "true"
          }
          env {
            name  = "LOGGER_LEVEL"
            value = "PRODUCTION"
          }
          env {
            name  = "GODEBUG"
            value = "x509sha1=1"
          }
          env {
            name = "CSI_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "NODEGETINFO_WATCH_TIMEOUT_MINUTES"
            value = "1"
          }
          security_context {
            privileged = true
            capabilities {
              add = ["SYS_ADMIN"]
            }
            allow_privilege_escalation = true
          }
          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }
          volume_mount {
            name              = "pods-mount-dir"
            mount_path        = "/var/lib/kubelet"
            mount_propagation = "Bidirectional"
          }
          volume_mount {
            name       = "device-dir"
            mount_path = "/dev"
          }
          volume_mount {
            name       = "blocks-dir"
            mount_path = "/sys/block"
          }
          volume_mount {
            name       = "sys-devices-dir"
            mount_path = "/sys/devices"
          }
          port {
            name           = "healthz"
            container_port = "9808"
            protocol       = "TCP"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }
            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "5"
            failure_threshold     = "3"
          }
        }
        container {
          name  = "liveness-probe"
          image = "k8s.gcr.io/sig-storage/livenessprobe:v2.9.0"
          args = [
            "--v=4",
            "--csi-address=/csi/csi.sock"
          ]
          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }
        }
        volume {
          name = "registration-dir"
          host_path {
            path = "/var/lib/kubelet/plugins_registry"
            type = "Directory"
          }
        }
        volume {
          name = "plugin-dir"
          host_path {
            path = "/var/lib/kubelet/plugins/csi.vsphere.vmware.com"
            type = "DirectoryOrCreate"
          }
        }
        volume {
          name = "pods-mount-dir"
          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
        }
        volume {
          name = "device-dir"
          host_path {
            path = "/dev"
          }
        }
        volume {
          name = "blocks-dir"
          host_path {
            path = "/sys/block"
            type = "Directory"
          }
        }
        volume {
          name = "sys-devices-dir"
          host_path {
            path = "/sys/devices"
            type = "Directory"
          }
        }
        toleration {
          effect   = "NoExecute"
          operator = "Exists"
        }
        toleration {
          effect   = "NoSchedule"
          operator = "Exists"
        }
      }
    }
  }
}


