#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## RBAC setup
header "Configuring kubelet on worker nodes ..."

for instance in $WORKER0_HOST_PUBLIC $WORKER1_HOST_PUBLIC; do
  log "Configuring kubelet on worker instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-worker-config-kubelet.sh

  cat > $script << eof
HOSTNAME=\$(curl http://169.254.169.254/latest/meta-data/public-hostname)
sudo mv \${HOSTNAME}-key.pem \${HOSTNAME}.pem /var/lib/kubelet/
sudo mv \${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo mv ca.pem /var/lib/kubernetes/

# Create the kubelet config file
cat << EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS: 
  - "10.32.0.10"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/\${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/\${HOSTNAME}-key.pem"
EOF

# Create the kubelet unit file
cat << EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\\\
  --config=/var/lib/kubelet/kubelet-config.yaml \\\\
  --container-runtime=remote \\\\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\\\
  --image-pull-progress-deadline=2m \\\\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\\\
  --network-plugin=cni \\\\
  --register-node=true \\\\
  --v=2 \\\\
  --hostname-override=\${HOSTNAME} \\\\
  --allow-privileged=true
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
eof

  ssh ubuntu@$instance 'bash -s' < $script
done
