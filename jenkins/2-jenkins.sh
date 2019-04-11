#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Setting up k8s Controller manager
header "Installing Jenkins Master ..."

for instance in $JENKINS_MASTER_HOST_PUBLIC; do

  script=${ARTIFACTS_DIR}/installing-jenkins.sh

  cat > $script << eof
  echo " - Generating Jenkins Dockerfile ..."

  cat << EOF | sudo tee /home/ec2-user/Dockerfile-Jenkins
FROM jenkins/jenkins:lts
# if we want to install via apt
USER root
RUN apt-get update
RUN apt-get install \\\\
    apt-transport-https \\\\
    ca-certificates \\\\
    curl \\\\
    gnupg2 \\\\
    vim \\\\
    software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \\\\
   "deb [arch=amd64] https://download.docker.com/linux/debian \\\\
   \\\$(lsb_release -cs) \\\\
   stable"
RUN apt-get update
RUN apt-get install docker-ce docker-ce-cli containerd.io -y
# drop back to the regular jenkins user - good practice
USER root
EOF

  echo " - Start Jenkins container ..."
  docker build . -f /home/ec2-user/Dockerfile-Jenkins -t jenkins/jenkins-container:lts
  docker run --rm -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins/jenkins-container:lts

  IP=\$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
  sleep 10
  docker exec \$(docker ps -a | grep jenkins-container | awk '{print \$1}') curl "localhost:8080/login?from=%2F"
  echo " - Jenkins onetime password is: \$(cat /var/jenkins_home/secrets/initialAdminPassword)"
  docker exec \$(docker ps -a | grep jenkins-container | awk '{print \$1}') cat /var/jenkins_home/secrets/initialAdminPassword
  echo "http://\${IP}:8080"

eof

  ssh ec2-user@$instance 'bash -s' < $script
done
