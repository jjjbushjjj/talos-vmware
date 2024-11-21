## Deploy talos kubernetes cluster on vmware


Main source for documentation: [talos](https://www.talos.dev)

Vmware specific part: [talos vmware](https://www.talos.dev/v1.8/talos-guides/install/virtualized-platforms/vmware/)

### Stages
There are 2 terraform configurations here.

* `cluster-bootstrap` Initial cluster provision. Modify and run this if you need to do something with virtual machines and talos itself.
* `cluster-configure` Populate cluster with additional software. Here you could install whatever you want to see in kubernetes.

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

### Cluster Bootstrap

What is terraform is actually do:

* Creates bunch of vms separated by 2 roles (control plane, worker)
* Adds A records in powerdns
* Generates talos configs for nodes
* Bootstrap cluster
* Generates talosconfig
* Generates kubeconfig <- This is essential for Configuration stage. Providers there use it for access.

* Scale UP Cluster

  Add node configutation block in `terraform.tfvars`

* Scale DOWN Cluster

  - `talosctl -n <IP.of.node.to.remove> reset`
  - `kubectl delete node <nodename>`
  - Remove block for node in `terraform.tfvars`

### Cluster Configure

* Install additional software into the cluster
  - cilium CNI (This one runs at bootstrap stage)
  - vsphere CSI
  - nginx-ingress controller


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
