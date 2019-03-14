#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Move kubeconfig files to the worker nodes
echo "Move Kubeconfig files to the worker nodes ..."
echo "--------"
scp ${ARTIFACTS_DIR}/${WORKER0_HOST_PUBLIC}.kubeconfig ${ARTIFACTS_DIR}/kube-proxy.kubeconfig ubuntu@${WORKER0_IP_PUBLIC}:~/
scp ${ARTIFACTS_DIR}/${WORKER1_HOST_PUBLIC}.kubeconfig ${ARTIFACTS_DIR}/kube-proxy.kubeconfig ubuntu@${WORKER1_IP_PUBLIC}:~/
echo "--------"


## Move kubeconfig files to the controller nodes
echo "Move Kubeconfig files to the controller nodes ..."
echo "--------"
scp ${ARTIFACTS_DIR}/admin.kubeconfig ${ARTIFACTS_DIR}/kube-controller-manager.kubeconfig ${ARTIFACTS_DIR}/kube-scheduler.kubeconfig ubuntu@${CTRL0_IP_PUBLIC}:~/
scp ${ARTIFACTS_DIR}/admin.kubeconfig ${ARTIFACTS_DIR}/kube-controller-manager.kubeconfig ${ARTIFACTS_DIR}/kube-scheduler.kubeconfig ubuntu@${CTRL1_IP_PUBLIC}:~/
echo "--------"

