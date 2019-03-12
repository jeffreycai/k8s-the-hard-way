#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
mkdir -p $ARTIFACTS_DIR
cd $ARTIFACTS_DIR

# Move the certificate files to worker nodes
echo "Move the certificate files to worker nodes ..."
echo "--------"
scp ca.pem ${WORKER0_HOST}-key.pem ${WORKER0_HOST}.pem ubuntu@${WORKER0_HOST}:~/
scp ca.pem ${WORKER1_HOST}-key.pem ${WORKER1_HOST}.pem ubuntu@${WORKER1_HOST}:~/
echo "--------"

# Move certificate files to the controller nodes
echo "Move certificate files to the controller nodes ..."
echo "--------"
scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ubuntu@${CTRL0_IP}:~/
scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ubuntu@${CTRL1_IP}:~/
echo "--------"

