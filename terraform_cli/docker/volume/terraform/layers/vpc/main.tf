variable "instances" {
  type = "list"
  default = ["K8sMaster1", "K8sMaster2", "K8sWorker1", "K8sWorker2"]
}

# provider
provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "default"
}

# vpc
resource "aws_vpc" "k8s_the_hard_way" {
  cidr_block = "172.32.0.0/16"

  tags {
    Name = "k8s_the_hard_way"
  }
}

# ec2
