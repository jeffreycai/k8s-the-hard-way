#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Enable services
header "Installing nginx and setup /healthz health check point ..."

for instance in $CTRL0_IP_PUBLIC $CTRL1_IP_PUBLIC; do
  log "Installing nginx and config health check for instance $instance .."

  script=${ARTIFACTS_DIR}/${instance}-apiserver-healthcheck.sh

  cat > $script << eof
echo ".. Install nginx .."
sudo apt-get update
sudo apt-get install -y nginx

echo ".. Nginx conf file ..."
cat > kubernetes.default.svc.cluster.local << EOF
server {
  listen      80;
  server_name kubernetes.default.svc.cluster.local;

  location /healthz {
     proxy_pass                    https://127.0.0.1:6443/healthz;
     proxy_ssl_trusted_certificate /var/lib/kubernetes/ca.pem;
  }
}
EOF

sudo mv kubernetes.default.svc.cluster.local /etc/nginx/sites-available/kubernetes.default.svc.cluster.local
sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sudo systemctl enable nginx
sleep 2

echo ".. Check health endpoint ..."
curl -H "Host: kubernetes.default.svc.cluster.local" -i http://127.0.0.1/healthz
sleep 2

eof

  ssh ubuntu@$instance 'bash -s' < $script
done
