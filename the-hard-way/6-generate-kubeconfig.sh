#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Generate a kubelet kubeconfig for each worker node
for instance in $WORKER0_HOST $WORKER1_HOST; do
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