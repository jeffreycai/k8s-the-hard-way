FROM alpine:latest

WORKDIR /root

# arguments / environment vars
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

# dockerize
COPY tools/dockerize /usr/bin
RUN chmod +x /usr/bin/dockerize

# update alpine
RUN apk update
RUN apk add vim bash openssh python py-pip ca-certificates \
    && rm -rf /var/cache/apk/*

# install aws cli
RUN pip install awscli

# update aws credentials
RUN mkdir /root/.aws
COPY templates/credentials.tmpl /root/.aws/credentials.tmpl
RUN dockerize -template /root/.aws/credentials.tmpl:/root/.aws/credentials

# install terraform
ADD https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip /root
RUN unzip terraform_0.11.8_linux_amd64.zip
RUN mv terraform /usr/bin

# entrypoint
COPY entrypoint.sh /etc/entrypoint.sh