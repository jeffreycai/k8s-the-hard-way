FROM alpine:latest

WORKDIR /root

# update alpine
RUN apk update
RUN apk add vim bash openssh

# install client tools: cfssl, kubectl
RUN wget \
    https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
    https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

RUN chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
RUN mv cfssl_linux-amd64 /usr/local/bin/cfssl
RUN mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

# entrypoint
COPY entrypoint.sh /etc/entrypoint.sh