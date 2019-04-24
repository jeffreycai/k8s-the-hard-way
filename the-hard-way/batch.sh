#/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $BASEDIR/functions.sh

rm -rf $ARTIFACTS_DIR

# bash 1-local-client.sh
bash 2-local-client-certs.sh
bash 3-local-apiserver-cert.sh
bash 4-service-account-key-pair.sh
bash 5-distributing-certs.sh
bash 6-generate-kubeconfig.sh
bash 7-distributing-the-kubeconfig-files.sh
bash 8-generate-data-encryption-config.sh
bash 9-bootstrap-etcd.sh
bash 10-control-plane-binary.sh
bash 11-control-plane-apiserver.sh
bash 12-control-plane-controller-manager.sh
bash 13-control-plane-scheduler.sh
bash 14-enable-api-ctlmg-schl.sh
bash 15-k8sapi-http-health-check.sh
bash 16-setup-rbac.sh
bash 17-setup-apiserver-frontend-lb.sh
bash 18-installing-wkr-node-binaries.sh
bash 19-configuring-containerd.sh
bash 20-configuring-kubelet.sh
bash 21-configuring-kube-proxy.sh
bash 22-start-worker-services.sh
bash 23-local-kubectl-setup.sh
bash 24-Installing-weave-net.sh