#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "JENKINS_MASTER_HOST_PUBLIC ------- $JENKINS_MASTER_HOST_PUBLIC "
echo "JENKINS_MASTER_IP_PUBLIC --------- $JENKINS_MASTER_IP_PUBLIC "
echo "JENKINS_MASTER_HOST_PRIVATE ------ $JENKINS_MASTER_HOST_PRIVATE "
echo "JENKINS_MASTER_IP_PRIVATE -------- $JENKINS_MASTER_IP_PRIVATE "
echo "JENKINS_MASTER_HOSTNAME ---------- $JENKINS_MASTER_HOSTNAME "