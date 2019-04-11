#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker $USER
sudo reboot

docker pull jenkins/jenkins:lts
#docker run --rm -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
docker run --rm -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins/myjenkins
# debug:
# docker exec -it $(docker ps | grep jenkins | awk '{print $1}') /bin/bash
# cat /var/jenkins_home/secrets/initialAdminPassword

docker pull alpine/socat
docker run -d --restart=always     -p 127.0.0.1:2376:2375     -v /var/run/docker.sock:/var/run/docker.sock     alpine/socat     tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
