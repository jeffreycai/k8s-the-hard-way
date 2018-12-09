#!/bin/bash

source functions.sh

## provision certificate authority (to get ca-key.pen and ca.pem)
cd ~/
mkdir kthw
cd kthw

## provision certificate authority
echo "Provisioning CA ..."
provision_ca
# At the end, you'll have the following files under ~/kthw folder:

# ~/kthw/
# ├── ca-config.json
# ├── ca.csr
# ├── ca-csr.json
# ├── ca-key.pem
# └── ca.pem


## Now you've provisioned ca of K8s cluster, let's generate clients certs 
# - `admin`, `kubelet` (one for each worker node)
# - `kube-controller-manager`, `kube-proxy` and `kube-scheduler`
provision_admin_client_certs