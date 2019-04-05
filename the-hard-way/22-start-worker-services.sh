#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## RBAC setup
header "Starting services on worker nodes ..."

for instance in $WORKER0_IP_PUBLIC $WORKER1_IP_PUBLIC; do
  log "Starting services on worker instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-worker-config-kube-proxy.sh

  cat > $script << eof
sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy

# Check status
sudo systemctl status containerd kubelet kube-proxy

# Check k8s nodes
kubectl get nodes

eof

  ssh ubuntu@$instance 'bash -s' < $script
done
