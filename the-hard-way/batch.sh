#/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $BASEDIR/functions.sh

rm -rf $ARTIFACTS_DIR

# bash 1-local-client.sh
bash 2-local-client-certs.sh
bash 3-local-apiserver-cert.sh
bash 4-service-account-key-pair.sh
bash 5-distributing-certs.sh
bash 6-generate-kubeconfig.sh
bash 7-distributing-the-kubeconfig-files.sh
bash 8-generate-data-encryption-config.sh
bash 9-bootstrap-etcd.sh
