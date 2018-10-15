#!/bin/bash
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "Env vars AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY needs to be set first"
  exit 1
fi

docker build \
  --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -t terraform_cli .