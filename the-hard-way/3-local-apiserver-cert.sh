#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
cd ~/
mkdir -p kthw
cd kthw

## provision Kubernetes API Server Certificate
echo "Provisioning Kube API Server Certificate ..."
provision_k8s_server_cert
# At the end, you'll have the following files under ~/kthw folder:
# ~/kthw/
# ├── kubernetes.csr
# ├── kubernetes-csr.json
# ├── kubernetes-key.pem
# ├── kubernetes.pem