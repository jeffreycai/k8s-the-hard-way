#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
cd ~/
rm -rf $ARTIFACTS_DIR
mkdir -p $ARTIFACTS_DIR
cd $ARTIFACTS_DIR

## provision certificate authority
header "Provisioning CA ..."
provision_ca
# At the end, you'll have the following files under ARTIFACTS_DIR folder:
# $ARTIFACTS_DIR/
# ├── ca-config.json
# ├── ca.csr
# ├── ca-csr.json
# ├── ca-key.pem
# └── ca.pem


## Now you've provisioned ca of K8s cluster, let's generate clients certs 
# - `admin`, `kubelet` (one for each worker node)
# - `kube-controller-manager`, `kube-proxy` and `kube-scheduler`
header "Provisioning Admin clent cert .."
provision_admin_client_certs
# At the end, you have the following files generated:
# $ARTIFACTS_DIR/
# ├── admin.csr
# ├── admin-csr.json
# ├── admin-key.pem
# ├── admin.pem

header "Provisioning k8s client certs ..."
provision_k8s_client_certs
# At the end, you have the following files generated:
# $ARTIFACTS_DIR/
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com.csr
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com-csr.json
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com-key.pem
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com.pem
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com.csr
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com-csr.json
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com-key.pem
# └── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com.pem

header "Provisioning Controller Manager Client certificate ..."
provision_k8s_ctl_mg_client_cert
# At the end, you have the following files generated:
# $ARTIFACTS_DIR/
# ├── kube-controller-manager.csr
# ├── kube-controller-manager-csr.json
# ├── kube-controller-manager-key.pem
# └── kube-controller-manager.pem

header "Provisioning Kube Proxy Client certificate ..."
provision_k8s_pxy_client_cert
# At the end, you have the following files generated:
# $ARTIFACTS_DIR/
# ├── kube-proxy.csr
# ├── kube-proxy-csr.json
# ├── kube-proxy-key.pem
# └── kube-proxy.pem

header "Provisioning Kube Scheduler Client Certificate ..."
provision_k8s_sclr_client_cert
# At the end, you have the following files generated:
# $ARTIFACTS_DIR/
# ├── kube-scheduler.csr
# ├── kube-scheduler-csr.json
# ├── kube-scheduler-key.pem
# └── kube-scheduler.pem