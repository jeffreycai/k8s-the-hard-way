#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "WORKER0_HOST -------- $WORKER0_HOST"
echo "WORKER0_IP ---------- $WORKER0_IP"
echo "WORKER1_HOST -------- $WORKER1_HOST"
echo "WORKER1_IP ---------- $WORKER1_IP"
echo "CTRL0_HOST ---------- $CTRL0_HOST"
echo "CTRL0_IP ------------ $CTRL0_IP"
echo "CTRL1_HOST ---------- $CTRL1_HOST"
echo "CTRL1_IP ------------ $CTRL1_IP"
echo "API_LB_HOST --------- $API_LB_HOST"
echo "API_LB_IP ----------- $API_LB_IP"
echo "KUBERNETES_ADDRESS -- $KUBERNETES_ADDRESS"
echo "ARTIFACTS_DIR ------- $ARTIFACTS_DIR"




