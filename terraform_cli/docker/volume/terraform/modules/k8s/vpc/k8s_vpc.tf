variable "vpc_cidr" {
  type = "string"
}
variable "subnet_k8s_master_a_cidr" {
  type = "string"
}
variable "subnet_k8s_master_b_cidr" {
  type = "string"
}

# provider
provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "default"
}

# vpc
resource "aws_vpc" "vpc_k8s" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "k8s"
  }
}

# subnet
resource "aws_subnet" "subnet_k8s_master_a" {
  vpc_id = "${aws_vpc.vpc_k8s.id}"
  cidr_block = "${var.subnet_k8s_master_a_cidr}"
  availability_zone = "ap-southeast-2a"
  tags {
    Name = "subnet-k8s-master-a"
  }
}

resource "aws_subnet" "subnet_k8s_master_b" {
  vpc_id = "${aws_vpc.vpc_k8s.id}"
  cidr_block = "${var.subnet_k8s_master_b_cidr}"
  availability_zone = "ap-southeast-2a"
  tags {
    Name = "subnet-k8s-master-b"
  }
}

# output
output "vpc_id" {
  value = "${aws_vpc.vpc_k8s.id}"
}
output "subnet_k8s_master_a_id" {
  value = "${aws_subnet.subnet_k8s_master_a.id}"
}
output "subnet_k8s_master_b_id" {
  value = "${aws_subnet.subnet_k8s_master_a.id}"
}