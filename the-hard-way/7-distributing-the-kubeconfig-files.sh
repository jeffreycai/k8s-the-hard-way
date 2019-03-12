#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Move kubeconfig files to the worker nodes
scp ${ARTIFACTS_DIR}/${WORKER0_HOST}.kubeconfig ${ARTIFACTS_DIR}/kube-proxy.kubeconfig ubuntu@${WORKER0_IP}:~/
scp ${ARTIFACTS_DIR}/${WORKER1_HOST}.kubeconfig ${ARTIFACTS_DIR}/kube-proxy.kubeconfig ubuntu@${WORKER1_IP}:~/


