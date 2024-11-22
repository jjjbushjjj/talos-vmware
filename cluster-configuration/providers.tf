terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "talos_mng_configuration/k8s.tfstate"
    region                      = "us-east-1"
    endpoints                   = { s3 = "https://minio.lenta.tech" }
    skip_requesting_account_id  = "true"
    force_path_style            = "true"
    skip_credentials_validation = "true"
    #access_key                  = "" - # optional by default used your aws creds. Set env AWS_ACCESS_KEY_ID
    #secret_key                  = "" - # optional by default used your aws creds. Set env AWS_SECRET_ACCESS_KEY
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.4.0"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}

provider "vault" {
  address = var.vault_addr
}

provider "kubernetes" {
  # config_path = local_file.kubectl.filename
  config_path = "${path.module}/kubeconfig"
}

provider "powerdns" {
  api_key        = data.vault_generic_secret.talos.data["powerdns_api_key"]
  server_url     = var.powerdns_server_url
  insecure_https = true
}

# provider "kubernetes" {
#   host                   = resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
#   client_key             = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
#   client_certificate     = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
#   cluster_ca_certificate = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
# }

# provider "kubectl" {
#   # host                   = resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
#   # client_key             = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
#   # client_certificate     = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
#   # cluster_ca_certificate = base64decode(resource.talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
#   # load_config_file       = false
# }

