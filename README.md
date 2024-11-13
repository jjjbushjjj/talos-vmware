## Deploy talos kubernetes cluster on vmware


Main source for documentation: [talos](https://www.talos.dev)

Vmware specific part: [talos vmware](https://www.talos.dev/v1.8/talos-guides/install/virtualized-platforms/vmware/)

### Init terraform
Before starting terraform init, make sure that env variables are set

You need to provide 2 env variables for vault provider
* VAULT_ADDR=https://vault.lenta.tech:8200/
* VAULT_TOKEN=<Your valid vault acces token>

You need to provide 2 env variables for s3 state backend
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Run `terraform init`

Run `terraform plan` `terraform apply`

### Configuration day 0-1

What is terraform is actually do:

* Creates bunch of vms separated by 2 roles (control plane, worker)
* Adds A records in powerdns
* Generates talos configs for nodes
* Bootstrap cluster
* Generates talosconfig
* Generates kubeconfig
* Install additional software into the cluster
  - cilium SNI (This one runs at bootstrap stage)
  - vsphere CSI

### Configuration day 2

* Scale UP Cluster

  Add node configutation block in `terraform.tfvars`

* Scale DOWN Cluster

  - `talosctl -n <IP.of.node.to.remove> reset`
  - `kubectl delete node <nodename>`
  - Remove block for node in `terraform.tfvars`

Run `terraform plan` `terraform apply`

### Get configs for kubectl and talosctl

`terraform output --raw talos_client_config > talosconf`

`terraform output --raw talos_kubectl_config > kubectlconf`

*talosctl* `export TALOSCONFIG=talosconf`

*kubectl* `export KUBECONFIG=kubectlconf`

[Where to get them](https://www.talos.dev/v1.8/introduction/quickstart/)


### Fun part
[Give me my ssh!](https://www.siderolabs.com/blog/how-to-ssh-into-talos-linux/)


### TODO
Thereis some bug with Content library image upload. Probably due lack of internetes
on Vmware Vcenter.
