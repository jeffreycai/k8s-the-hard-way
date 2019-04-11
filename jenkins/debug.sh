#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ssh ec2-user@$JENKINS_MASTER_HOST_PUBLIC