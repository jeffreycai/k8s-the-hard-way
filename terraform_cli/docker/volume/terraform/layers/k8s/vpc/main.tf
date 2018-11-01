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
module "k8s_vpc" {
  source = "../../../modules/k8s/vpc"
  vpc_cidr = "${var.vpc_cidr}"
  subnet_k8s_master_a_cidr = "${var.subnet_k8s_master_a_cidr}"
  subnet_k8s_master_b_cidr = "${var.subnet_k8s_master_b_cidr}"
}

# ec2
resource "aws_network_interface" "k8s_master_1" {
  subnet_id = "${module.k8s_vpc.subnet_k8s_master_a_id}"
  tags {
    Name = "k8s_master_a_network_interface"
  }
}

resource "aws_instance" "k8s_master_1" {
  ami = "ami-0789a5fb42dcccc10"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.k8s_master_1.id}"
    device_index = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
}