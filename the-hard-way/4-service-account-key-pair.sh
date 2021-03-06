#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## provision certificate authority (to get ca-key.pen and ca.pem)
mkdir -p $ARTIFACTS_DIR
cd $ARTIFACTS_DIR

## provision Kubernetes Service Account Key Pair
echo "Provisioning Service Account Key Pair ..."
provision_service_account_key_pair
# At the end, you'll have the following files under $ARTIFACTS_DIR folder:
# $ARTIFACTS_DIR/
# ├── service-account.csr
# ├── service-account-csr.json
# ├── service-account-key.pem
# └── service-account.pem