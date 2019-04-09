#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## RBAC setup
# creating a ClusterRole and binding it to the kubernetes user so that those permissions will be in place
# we only need to run once on one node
header "Setting up RBAC ..."

for instance in $CTRL0_HOST_PUBLIC; do
  log "Setting up RBAC on instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-rbac.sh

  cat > $script << eof

# RBAC cluster role
echo "-- Create cluster role conf file --"
cat << EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

echo "-- Bind the role to kubernetes user --"
cat << EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF

eof

  ssh ubuntu@$instance 'bash -s' < $script
done
