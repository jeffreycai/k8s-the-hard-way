#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Setting up k8s Controller manager
header "Setting up the Kubernetes Controller Manager ..."

for instance in $CTRL0_IP_PUBLIC $CTRL1_IP_PUBLIC; do
  log "Setting up k8s controller manager for instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-ctl-controller-manager.sh

  cat > $script << eof
# Copy kube config manager conf file
sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/

# Generate the kube-controller-manager systemd unit file
cat << EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=0.0.0.0 \\
  --cluster-cidr=10.200.0.0/16 \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \\
  --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \\
  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/var/lib/kubernetes/ca.pem \\
  --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
eof

  ssh ubuntu@$instance 'bash -s' < $script
done
