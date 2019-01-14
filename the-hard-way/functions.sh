
## Get the ips and hostnames
WORKER0_HOST=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.public_dns')
WORKER0_IP=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-1"].primary.attributes.public_ip')
WORKER1_HOST=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.public_dns')
WORKER1_IP=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-wk-2"].primary.attributes.public_ip')
CTRL0_HOST=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.private_dns')
CTRL0_IP=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-1"].primary.attributes.public_ip')
CTRL1_HOST=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.private_dns')
CTRL1_IP=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-ctl-2"].primary.attributes.public_ip')
API_LB_HOST=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.private_dns')
API_LB_IP=$(cat ../terraform/aws/cloudops-sandbox/bastion/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.ks-lb-1"].primary.attributes.public_ip')


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
  cat > ${WORKER0_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER0_HOST}",
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
    -hostname=${WORKER0_IP},${WORKER0_HOST} \
    -profile=kubernetes \
    ${WORKER0_HOST}-csr.json | cfssljson -bare ${WORKER0_HOST}

  # worker #1 csr
  cat > ${WORKER1_HOST}-csr.json << EOF
{
  "CN": "system:node:${WORKER1_HOST}",
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
    -hostname=${WORKER1_IP},${WORKER1_HOST} \
    -profile=kubernetes \
    ${WORKER1_HOST}-csr.json | cfssljson -bare ${WORKER1_HOST}

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


## Provisioning Kube Scheduler Client Certificate
provision_k8s_server_cert() {
  CERT_HOSTNAME=10.32.0.1,$CTRL0_IP,$CTRL0_HOST,$CTRL1_IP,$CTRL1_HOST,$API_LB_IP,$API_LB_HOST,127.0.0.1,localhost,kubernetes.default

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