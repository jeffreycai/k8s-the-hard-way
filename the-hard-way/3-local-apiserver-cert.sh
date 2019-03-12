#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
mkdir -p $ARTIFACTS_DIR
cd $ARTIFACTS_DIR

## provision Kubernetes API Server Certificate
echo "Provisioning Kube API Server Certificate ..."
provision_k8s_server_cert
# At the end, you'll have the following files under $ARTIFACTS_DIR folder:
# $ARTIFACTS_DIR/
# ├── kubernetes.csr
# ├── kubernetes-csr.json
# ├── kubernetes-key.pem
# ├── kubernetes.pem