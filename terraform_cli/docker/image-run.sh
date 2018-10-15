#!/bin/bash

RESULT=$(docker ps -a | grep terraform-cli)

if [ -z "$RESULT" ]; then
  docker run --name terraform-cli \
             -v $(pwd)/volume:/root/docker \
             -it terraform_cli /bin/bash
else
  docker start terraform-cli && docker attach terraform-cli
fi

