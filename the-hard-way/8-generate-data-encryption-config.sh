#!/bin/bash

############################
# Encrpt secrect data at rest
############################

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

##  Generate the K8s Data encryption config file containing the encryption key
echo "Generate the K8s Data encryption config file containing the encryption key ..."
echo "--------"
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > ${ARTIFACTS_DIR}/encryption-config.yaml << EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
echo ${ARTIFACTS_DIR}/encryption-config.yaml
echo "--------"

## Copy the file to both controller servers:
echo "Copy the file to both controller servers ..."
echo "--------"
scp ${ARTIFACTS_DIR}/encryption-config.yaml ubuntu@${CTRL0_IP_PUBLIC}:~/
scp ${ARTIFACTS_DIR}/encryption-config.yaml ubuntu@${CTRL1_IP_PUBLIC}:~/
echo "--------"