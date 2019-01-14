#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
cd ~/
mkdir -p kthw
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
echo "Provisioning Admin clent cert .."
provision_admin_client_certs
# At the end, you have the following files generated:
# ~/kthw/
# ├── admin.csr
# ├── admin-csr.json
# ├── admin-key.pem
# ├── admin.pem

echo "Provisioning k8s client certs ..."
provision_k8s_client_certs
# At the end, you have the following files generated:
# ~/kthw/
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com.csr
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com-csr.json
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com-key.pem
# ├── ec2-13-211-143-228.ap-southeast-2.compute.amazonaws.com.pem
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com.csr
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com-csr.json
# ├── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com-key.pem
# └── ec2-3-104-54-208.ap-southeast-2.compute.amazonaws.com.pem

echo "Provisioning Controller Manager Client certificate ..."
provision_k8s_ctl_mg_client_cert
# At the end, you have the following files generated:
# ~/kthw/
# ├── kube-controller-manager.csr
# ├── kube-controller-manager-csr.json
# ├── kube-controller-manager-key.pem
# └── kube-controller-manager.pem

echo "Provisioning Kube Proxy Client certificate ..."
provision_k8s_pxy_client_cert
# At the end, you have the following files generated:
# ~/kthw/
# ├── kube-proxy.csr
# ├── kube-proxy-csr.json
# ├── kube-proxy-key.pem
# └── kube-proxy.pem

echo "Provisioning Kube Scheduler Client Certificate ..."
provision_k8s_sclr_client_cert
# At the end, you have the following files generated:
# ~/kthw/
# ├── kube-scheduler.csr
# ├── kube-scheduler-csr.json
# ├── kube-scheduler-key.pem
# └── kube-scheduler.pem