#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Enable services
header "Enabling Kubernetes services, kube-apiserver, kube-controller-manager, kube-scheduler ..."

for instance in $CTRL0_HOST_PUBLIC $CTRL1_HOST_PUBLIC; do
  log "Enabling kubernetes services, kube-apiserver, kube-controller-manager, kube-scheduler for instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-enable-services.sh

  cat > $script << eof
echo ".. Reload daemon .."
sudo systemctl daemon-reload
sleep 2

echo ".. Eanble services ..."
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
sleep 2

echo ".. Check systemctl status ..."
sudo systemctl status kube-apiserver kube-controller-manager kube-scheduler
sleep 2

echo ".. Check kubectl status .."
kubectl get componentstatuses --kubeconfig admin.kubeconfig
sleep 2
eof

  ssh ubuntu@$instance 'bash -s' < $script
done
