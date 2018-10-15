#!/bin/bash
docker run --name k8s-cli -v $(pwd)/volume:/root/docker -it k8s_cli 