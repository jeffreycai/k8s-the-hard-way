#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Setting up k8s Controller manager
header "Installing Jenkins Master ..."

for instance in $JENKINS_MASTER_HOST_PUBLIC; do
  log "Installing server packages $instance .."

  script=${ARTIFACTS_DIR}/installing-server-packages.sh

  cat > $script << eof
sudo yum update -y
sudo yum install docker vim -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker \$USER
sudo reboot
eof

  ssh ec2-user@$instance 'bash -s' < $script
done