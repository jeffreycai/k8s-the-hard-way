#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Setting up k8s scheduler
header "Setting up the Kubernetes Scheduler ..."

for instance in $CTRL0_IP_PUBLIC $CTRL1_IP_PUBLIC; do
  log "Setting up k8s scheduler for instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-ctl-scheduler.sh

  cat > $script << eof
# Copy scheduler k8s conf file
sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/

# Generate the kube-scheduler yaml config file
cat << EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: componentconfig/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

# Create the kube-scheduler systemd unit file:
cat << EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\\\
  --config=/etc/kubernetes/config/kube-scheduler.yaml \\\\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
eof

  ssh ubuntu@$instance 'bash -s' < $script
done
