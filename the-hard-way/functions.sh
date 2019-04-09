## Get the ips and hostnames
WORKER0_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.public_dns')
WORKER0_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.private_dns')
WORKER0_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.public_ip')
WORKER0_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.private_ip')
WORKER1_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.public_dns')
WORKER1_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.private_dns')
WORKER1_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.public_ip')
WORKER1_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.private_ip')
CTRL0_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.private_dns')
CTRL0_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.public_dns')
CTRL0_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.public_ip')
CTRL0_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.private_ip')
CTRL1_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.private_dns')
CTRL1_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.public_dns')
CTRL1_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.public_ip')
CTRL1_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.private_ip')
API_LB_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.public_dns')
API_LB_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.public_ip')
API_LB_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.private_dns')
API_LB_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.private_ip')

## prepare HOSTNAME vars
IFS_BAK=$IFS
IFS="."
for word in $WORKER0_HOST_PRIVATE; do
  WORKER0_HOSTNAME=$word
  break
done
for word in $WORKER1_HOST_PRIVATE; do
  WORKER1_HOSTNAME=$word
  break
done
for word in $CTRL0_HOST_PRIVATE; do
  CTRL0_HOSTNAME=$word
  break
done
for word in $CTRL1_HOST_PRIVATE; do
  CTRL1_HOSTNAME=$word
  break
done
for word in $API_LB_HOST_PRIVATE; do
  API_LB_HOSTNAME=$word
  break
done
IFS=$IFS_BAK


KUBERNETES_ADDRESS=$API_LB_IP_PRIVATE
ARTIFACTS_DIR=$(echo ~)/kthw


## Helper functions
header() {
  echo "*********************"
  echo $1
  echo "*********************"
}

log() {
  echo "- $1"
}



## Provision certificate authority
provision_ca() {
    # ca config file
    cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

    # ca csr file
    cat > ca-csr.json << EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF

    # generate certificate authority
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca

}


## Provision client certs
provision_admin_client_certs() {
    # admin-csr file
    cat > admin-csr.json << EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

    cfssl gencert \
      -ca=ca.pem \
      -ca-key=ca-key.pem \
      -config=ca-config.json \
      -profile=kubernetes \
      admin-csr.json | cfssljson -bare admin

}


## Provision k8s client certs
provision_k8s_client_certs() {
  # worker #0 csr
  cat > ${WORKER0_HOST_PUBLIC}-csr.json << EOF
{
  "CN": "system:node:${WORKER0_HOST_PUBLIC}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  # worker #0 cert
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${WORKER0_IP_PRIVATE},${WORKER0_HOST_PUBLIC} \
    -profile=kubernetes \
    ${WORKER0_HOST_PUBLIC}-csr.json | cfssljson -bare ${WORKER0_HOST_PUBLIC}

  # worker #1 csr
  cat > ${WORKER1_HOST_PUBLIC}-csr.json << EOF
{
  "CN": "system:node:${WORKER1_HOST_PUBLIC}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  # workder #1 cert
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${WORKER1_IP_PRIVATE},${WORKER1_HOST_PUBLIC} \
    -profile=kubernetes \
    ${WORKER1_HOST_PUBLIC}-csr.json | cfssljson -bare ${WORKER1_HOST_PUBLIC}

}


## Provisioning Controller Manager Client certificate
provision_k8s_ctl_mg_client_cert() {
  # kube controller manager csr
  cat > kube-controller-manager-csr.json << EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  # generate k8s ctl manager cert
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}


## Provisioning Kube Proxy Client certificate
provision_k8s_pxy_client_cert() {
  cat > kube-proxy-csr.json << EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-proxy-csr.json | cfssljson -bare kube-proxy

}


## Provisioning Kube Scheduler Client Certificate
provision_k8s_sclr_client_cert() {
  cat > kube-scheduler-csr.json << EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}


## Provisioning Kube Server Certificate
provision_k8s_server_cert() {
  CERT_HOSTNAME=10.32.0.1,$CTRL0_IP_PRIVATE,$CTRL0_HOST_PUBLIC,$CTRL0_HOST_PRIVATE,$CTRL1_IP_PRIVATE,$CTRL1_HOST_PUBLIC,$CTRL1_HOST_PRIVATE,$API_LB_IP_PRIVATE,$API_LB_HOST_PUBLIC,$API_LB_HOST_PRIVATE,127.0.0.1,localhost,kubernetes.default

  cat > kubernetes-csr.json << EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${CERT_HOSTNAME} \
    -profile=kubernetes \
    kubernetes-csr.json | cfssljson -bare kubernetes

}


## Provision Kubernetes Service Account Key Pair
provision_service_account_key_pair() {

  cat > service-account-csr.json << EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    service-account-csr.json | cfssljson -bare service-account

}

## Generate a kubelet kubeconfig
generate_kubeconfig() {
  instance=$1

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=$ARTIFACTS_DIR/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_ADDRESS}:6443 \
    --kubeconfig=$ARTIFACTS_DIR/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=$ARTIFACTS_DIR/${instance}.pem \
    --client-key=$ARTIFACTS_DIR/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=$ARTIFACTS_DIR/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=$ARTIFACTS_DIR/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=$ARTIFACTS_DIR/${instance}.kubeconfig

  echo $ARTIFACTS_DIR/${instance}.kubeconfig
}

## Generate kube proxy config
generate_kube_proxy_config() {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=$ARTIFACTS_DIR/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_ADDRESS}:6443 \
    --kubeconfig=$ARTIFACTS_DIR/kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=$ARTIFACTS_DIR/kube-proxy.pem \
    --client-key=$ARTIFACTS_DIR/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=$ARTIFACTS_DIR/kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=$ARTIFACTS_DIR/kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=$ARTIFACTS_DIR/kube-proxy.kubeconfig

  echo $ARTIFACTS_DIR/kube-proxy.kubeconfig
}

## Generate Kube Controller Manager Config
generate_kube_ctler_manager_config() {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=$ARTIFACTS_DIR/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$ARTIFACTS_DIR/kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=$ARTIFACTS_DIR/kube-controller-manager.pem \
    --client-key=$ARTIFACTS_DIR/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=$ARTIFACTS_DIR/kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=$ARTIFACTS_DIR/kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=$ARTIFACTS_DIR/kube-controller-manager.kubeconfig

  echo $ARTIFACTS_DIR/kube-controller-manager.kubeconfig
}

## Generate Kube Scheduler Config
generate_kube_scheduler_config() {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=$ARTIFACTS_DIR/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$ARTIFACTS_DIR/kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=$ARTIFACTS_DIR/kube-scheduler.pem \
    --client-key=$ARTIFACTS_DIR/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=$ARTIFACTS_DIR/kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=$ARTIFACTS_DIR/kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=$ARTIFACTS_DIR/kube-scheduler.kubeconfig

  echo $ARTIFACTS_DIR/kube-scheduler.kubeconfig
}

## Generate an admin kubeconfig
generate_kube_admin_config() {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=$ARTIFACTS_DIR/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$ARTIFACTS_DIR/admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=$ARTIFACTS_DIR/admin.pem \
    --client-key=$ARTIFACTS_DIR/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=$ARTIFACTS_DIR/admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=$ARTIFACTS_DIR/admin.kubeconfig

  kubectl config use-context default --kubeconfig=$ARTIFACTS_DIR/admin.kubeconfig

  echo $ARTIFACTS_DIR/admin.kubeconfig
}

# convert a aws ec2 hostname, e.g. "ip-192-168-0-100" to ip, i.e. 192.168.0.100
hostname_to_ip() {
  hostname=$1
  echo $hostname | sed 's/ip-//' | sed 's/-/./g'
}