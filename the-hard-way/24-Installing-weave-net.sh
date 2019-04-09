#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Installing Weave Net
header "Installing Weave Net on worker nodes .."

# enable ip forwarding on workder nodes
for instance in $WORKER0_HOST_PUBLIC $WORKER1_HOST_PUBLIC; do
  log "Logging in to worker node $instance, and enable IP forwarding .."

  script=${ARTIFACTS_DIR}/${instance}-worker-installing-weave-net.sh

  cat > $script << eof
sudo sysctl net.ipv4.conf.all.forwarding=1
echo "net.ipv4.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf
eof

  ssh ubuntu@$instance 'bash -s' < $script
done

# Install Weave Net via kubectl
log "Install Weave Net"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.200.0.0/16"

# Verify
log "Verifying - make sure the Weave Net pods are up and running ..."
kubectl get pods -n kube-system

