#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## RBAC setup
header "Starting services on worker nodes ..."

for instance in $WORKER0_HOST_PUBLIC $WORKER1_HOST_PUBLIC; do
  log "Starting services on worker instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-worker-start-services.sh

  cat > $script << eof
sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy

# Check status
sudo systemctl status containerd kubelet kube-proxy

eof

  ssh ubuntu@$instance 'bash -s' < $script
done

# jump on a control node and check if the worker nodes are registered. (they should be NotReady for now)
for instance in $CTRL0_HOST_PUBLIC; do
  log "Check worker nodes registered on Control node $instance .."

  script=${ARTIFACTS_DIR}/${instance}-ctrl-get-nodes.sh

  cat > $script << eof
kubectl get nodes
eof

  ssh ubuntu@$instance 'bash -s' < $script
done

