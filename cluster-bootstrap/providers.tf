terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "talos_mng/k8s.tfstate"
    region                      = "us-east-1"
    endpoints                   = { s3 = "https://minio.lenta.tech" }
    skip_requesting_account_id  = "true"
    force_path_style            = "true"
    skip_credentials_validation = "true"
    #access_key                  = "" - # optional by default used your aws creds. Set env AWS_ACCESS_KEY_ID
    #secret_key                  = "" - # optional by default used your aws creds. Set env AWS_SECRET_ACCESS_KEY
  }

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.9.2"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.4.0"
    }
  }
}

provider "vault" {
  address = var.vault_addr
}

provider "vsphere" {
  user                 = data.vault_generic_secret.talos.data["vsphere_user"]
  password             = data.vault_generic_secret.talos.data["vsphere_password"]
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

provider "powerdns" {
  api_key        = data.vault_generic_secret.talos.data["powerdns_api_key"]
  server_url     = var.powerdns_server_url
  insecure_https = true
}

provider "talos" {}

# provider "kubernetes" {
#   config_path = local_file.kubectl.filename
# }
