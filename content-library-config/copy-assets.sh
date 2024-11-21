#!/bin/bash

set -e


# Copy assets to container
# Assume it runs in default ns and named govc

export KUBECONFIG=~/.kube/lenta-k8s.cfg
kubectl config use-context k8s-mng
kubectl cp vmware.sh govc:/

