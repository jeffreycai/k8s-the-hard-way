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
  # Add tomcat system user
  sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

  # Download
  cd /tmp
  wget http://www.strategylions.com.au/mirror/tomcat/tomcat-9/v9.0.17/bin/apache-tomcat-9.0.17.tar.gz
  tar -xf apache-tomcat-9.0.17.tar.gz
  sudo mv apache-tomcat-9.0.17 /opt/tomcat/
  sudo ln -s /opt/tomcat/apache-tomcat-9.0.17 /opt/tomcat/latest
  sudo chown -R tomcat: /opt/tomcat
  sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

  # Create systemd unit file
  cat << EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/jre"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl enable tomcat
  sudo systemctl start tomcat
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
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF

  sudo systemctl restart tomcat
}

# Install Jenkins
function install_jenkins() {
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo yum install -y jenkins
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
}

install_java_8
#install_tomcat_9
#update_tomcat
install_jenkins
# then go to http://<ip>:8080/, unlock Jenkins by copying the password at /var/lib/jenkins/secrets/initialAdminPassword
# then install plugins
# Suggested plugins:
# Folders OWASP Markup Formatter Build Timeout Credentials Binding Timestamper Workspace Cleanup Ant Gradle Pipeline GitHub Branch Source Pipeline: GitHub Groovy Libraries Pipeline: Stage View Git Subversion SSH Slaves Matrix Authorization Strategy PAM Authentication LDAP Email Extension Mailer
eof

  ssh ec2-user@$instance 'bash -s' < $script
done
