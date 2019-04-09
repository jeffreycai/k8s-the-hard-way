#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Setting up k8s Controller manager
header "Installing Jenkins Master ..."

for instance in $JENKINS_MASTER_HOST_PUBLIC; do
  log "Installing Jenkins on instance $instance .."

  script=${ARTIFACTS_DIR}/installing-jenkins-master.sh

  cat > $script << eof
# Install JAVA 8
function install_java_8() {
  echo "-- Install JAVA 8 --"
  sudo yum update -y
  sudo yum install -y java-1.8.0-openjdk
}

# Install Tomcat
function install_tomcat_9() {
  echo "-- Install Tomcat 9 --"
  sudo yum install -y wget
  wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M10/bin/apache-tomcat-9.0.0.M10.tar.gz
  tar xzf apache-tomcat-9.0.0.M10.tar.gz
  mv apache-tomcat-9.0.0.M10 tomcat9
}

# Update Tomcat user config
function update_tomcat() {
  # Add a Tomcat user
  cat << EOF | sudo tee /home/ec2-user/tomcat9/conf/tomcat-users.xml
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-jmx"/>
    <role rolename="admin-gui"/>
    <role rolename="admin-script"/>
    <user username="jeffrey" password="0172122a" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>
</tomcat-users>
EOF

  # Remove restriction of remote access 
  # https://www.digitalocean.com/community/questions/how-to-access-tomcat-8-admin-gui-from-different-host
  cat << EOF | sudo tee /home/ec2-user/tomcat9/webapps/manager/META-INF/context.xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
  <!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
</Context>
EOF

}

# Start Tomcat
function start_tomcat() {
  cd tomcat9
  ./bin/startup.sh 
}

# Download and Deploy Jenkins War
function download_and_deploy_jenkins_war() {
  cd
  wget http://updates.jenkins-ci.org/download/war/2.171/jenkins.war
  mv jenkins.war /home/ec2-user/tomcat9/webapps
  ./tomcat9/bin/shutdown.sh
  ./tomcat9/bin/startup.sh
}

install_java_8
install_tomcat_9
update_tomcat
start_tomcat
download_and_deploy_jenkins_war
eof

  ssh ec2-user@$instance 'bash -s' < $script
done
