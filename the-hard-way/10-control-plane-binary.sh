#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Install Control Plane binaries
header "Install Control Plane binaries ..."

for instance in $CTRL0_HOST_PUBLIC $CTRL1_HOST_PUBLIC; do
  log "Installing binaries for instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-ctl-binaries.sh

  cat > $script << eof
cd /tmp
sudo mkdir -p /etc/kubernetes/config

wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl"

chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/

echo " ---- Verifying ----"
echo " - kube-apiserver --version"
kube-apiserver --version

echo " - kube-controller-manager --version"
kube-controller-manager --version

echo " - kube-scheduler --version"
kube-scheduler --version

echo " - kubectl version"
kubectl version

sleep 5
eof
  
  ssh ubuntu@$instance 'bash -s' < $script
done
