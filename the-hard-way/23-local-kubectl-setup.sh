#!/bin/bash

## We will generate a local `kubeconfig` that will authenticate as the `admin` user and access the Kubernetes API through the `load balancer`.

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## kubectl config setup
header "Setting local kubectl to access k8s cluster remotely .."

log "Setting up kubeconfig"
cd $ARTIFACTS_DIR

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://${API_LB_HOST_PUBLIC}:6443

kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way

log "Verifying that everything working "
log "kubectl get pods"
kubectl get pods
log "kubectl get nodes"
kubectl get nodes
log "kubectl version"
kubectl version