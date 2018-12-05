variable "vpc_cidr" {}
variable "vpc_tag_name" {}

# VPC
resource "aws_vpc" "vpc-generic" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"

    tags {
        Name = "${var.vpc_tag_name}"
    }
}