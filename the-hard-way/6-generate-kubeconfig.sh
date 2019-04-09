#!/bin/bash

# Kubeconfigs can be generated using `kubectl`
## Use `kubectl config set-cluster` to set up the configuration for the location of the cluster
## Use `kubectl config set-credentials` to set the username and client certificate that will be used to authenticate
## Use `kubectl config set-context default` to set up the default context
## Use `kubectl config use-context default` to set the current context to the configuration we provided

# We will need several Kubeconfig files for various components of the Kubernetes cluster:
## Kubelet
## Kube-proxy
## Kube-controller-manager
## Kube-scheduler
## Admin

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Generate a kubelet kubeconfig for each worker node
for instance in $WORKER0_HOST_PUBLIC $WORKER1_HOST_PUBLIC; do
  echo "Generate kubeconfig for WORKER_HOST $instance ..."
  echo "--------"
  generate_kubeconfig $instance
  echo "--------"

done

## Generate a kube-proxy kubeconfig
echo "Generate kube-proxy config ..."
echo "--------"
generate_kube_proxy_config
echo "--------"

## Generate kube-controller-manager kubeconfig
echo "Generate kube-controller-manager config ..."
echo "--------"
generate_kube_ctler_manager_config
echo "--------"

## Generate kube-scheduler kubeconfig
echo "Generate kube-scheduler config ..."
echo "--------"
generate_kube_scheduler_config
echo "--------"

## Generate an admin kubeconfig
echo "Generate an admin config ..."
echo "--------"
generate_kube_admin_config
echo "--------"