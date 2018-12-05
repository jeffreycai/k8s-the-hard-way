variable "vpc_id" {}
variable "subnet_cidr" {}
variable "subnet_tag_name" {}
variable "subnet_az" {}

# Subnet
resource "aws_subnet" "subnet-generic" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.subnet_cidr}"
    availability_zone = "${var.subnet_az}"
  
    tags {
        Name = "${var.subnet_tag_name}"
    }
}