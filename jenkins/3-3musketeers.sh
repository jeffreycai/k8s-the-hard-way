#!/bin/bash

source functions.sh
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

header "Building 3 Musketeers image ..."

for instance in $JENKINS_MASTER_HOST_PUBLIC; do

  script=${ARTIFACTS_DIR}/building-3musketeers.sh

  cat > $script << eof
  echo " - Generating Jenkins Dockerfile ..."

  cat << EOF | sudo tee /home/ec2-user/Dockerfile-3musketeers
FROM docker

ENV AWS_CLI_VERSION=1.16.22
ENV JQ_VERSION=1.6
ENV JP_VERSION=0.1.3

## system packages and python packages
RUN apk -v --no-cache --update add \
        python \
        python-dev \
        libffi-dev \
        libc-dev \
        py-pip \
        ca-certificates \
        groff \
        less \
        bash \
        make \
        curl \
        wget \
        zip \
        git \
        gcc \
        openssh-client \
        openssl-dev \
        openssl \
        rsync \
        ansible \
        docker \
        nodejs \
        npm \
        xmlstarlet


RUN pip install --no-cache-dir --upgrade pip
#RUN pip install --no-cache-dir --upgrade awscli==\\\$AWS_CLI_VERSION docker-compose
RUN pip install --no-cache-dir --upgrade awscli==\\\$AWS_CLI_VERSION
RUN pip install --no-cache-dir --upgrade docker-compose
RUN pip install --no-cache-dir argparse && \\\\
    pip install --no-cache-dir boto3 && \\\\
    pip3 install --no-cache-dir boto3 && \\\\
    pip3 install --no-cache-dir pymongo && \\\\
    pip3 install --no-cache-dir GitPython && \\\\
    pip3 install --no-cache-dir pytz && \\\\
    pip install --no-cache-dir request && \\\\
    pip install --no-cache-dir json5 && \\\\
    pip install --no-cache-dir json_tools && \\\\
    update-ca-certificates

## npm packages
# cim: https://github.com/awslabs/aws-cloudformation-templates
RUN npm config set unsafe-perm true # https://github.com/npm/npm/issues/20861
RUN npm install cim -g

## utility tools

# jp: https://github.com/jmespath/jp
RUN curl -o /usr/local/bin/jp -L https://github.com/jmespath/jp/releases/download/\\\$JP_VERSION/jp-linux-amd64 && \\\\
    chmod +x /usr/local/bin/jp

# jq: https://github.com/stedolan/jq
RUN curl -o /usr/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-\\\$JQ_VERSION/jq-linux64 && \\\\
    chmod +x /usr/bin/jq
    
# dockerize: https://github.com/jwilder/dockerize
RUN apk add --no-cache openssl
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/\\\$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-\\\$DOCKERIZE_VERSION.tar.gz \\\\
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-\\\$DOCKERIZE_VERSION.tar.gz \\\\
    && rm dockerize-alpine-linux-amd64-\\\$DOCKERIZE_VERSION.tar.gz
    
# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/\\\$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \\\\
    chmod +x ./kubectl && \\\\
    mv ./kubectl /usr/local/bin/kubectl
    
# aws-iam-authenticator
RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator && \\\\
    chmod +x ./aws-iam-authenticator && \\\\
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_\\\$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \\\\
    chmod +x /tmp/eksctl && \\\\
    mv /tmp/eksctl /usr/local/bin

# helm: https://github.com/helm/helm/releases
RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && \\\\
    tar xvzf helm-v2.12.3-linux-amd64.tar.gz && \\\\
    mv linux-amd64/helm /usr/local/bin/ && \\\\
    rm -rf linux-amd64
# RUN helm init

## SSH keys
#RUN mkdir -p /root/.ssh
#COPY ssh/id_rsa.pub /root/.ssh
#COPY ssh/id_rsa /root/.ssh
#RUN chmod -R 400 /root/.ssh
#RUN ssh-keyscan ssh.gitlab.service.nsw.gov.au >> ~/.ssh/known_hosts

## volumes
VOLUME [ "/root/.aws" ]
VOLUME [ "/root/.ssh" ]
VOLUME [ "/opt/app" ]

WORKDIR /opt/app

CMD [ "/usr/bin/ansible", "--version" ]
EOF

  echo " - Build 3musketeers image ..."
  docker build . -f /home/ec2-user/Dockerfile-3musketeers -t 3musketeers

eof

  ssh ec2-user@$instance 'bash -s' < $script
done
