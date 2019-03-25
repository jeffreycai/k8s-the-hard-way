#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## RBAC setup
header "Setting nginx load balancing on Load balancer instance ..."

for instance in $API_LB_IP_PUBLIC; do
  log "Setting up nginx load balancer on instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-apiserver-lb.sh

  cat > $script << eof
echo " -- Install and enable nginx --"
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo mkdir -p /etc/nginx/tcpconf.d
echo "include /etc/nginx/tcpconf.d/*;" | sudo tee -a /etc/nginx/nginx.conf

CONTROLLER0_IP=$CTRL0_IP_PRIVATE
CONTROLLER1_IP=$CTRL1_IP_PRIVATE

echo " -- Nginx host conf --"
cat << EOF | sudo tee /etc/nginx/tcpconf.d/kubernetes.conf
stream {
    upstream kubernetes {
        server \$CONTROLLER0_IP:6443;
        server \$CONTROLLER1_IP:6443;
    }

    server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
EOF

echo " -- Reload server and verify --"
sudo nginx -s reload
curl -k https://localhost:6443/version
sleep 2

eof

  ssh ubuntu@$instance 'bash -s' < $script
done
