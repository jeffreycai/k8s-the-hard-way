variable "aws_account_id" {}
variable "aws_session_name" {}
variable "assume_role" {}
variable "vpc_cidr" {}
variable "vpc_tag_name" {}
variable "subnet_public_a_cidr" {}
variable "subnet_public_b_cidr" {}
variable "subnet_public_c_cidr" {}

# AWS Provider
provider "aws" {
    region = "ap-southeast-2"
    profile = "default"
    assume_role {
        role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.assume_role}"
        session_name = "${var.aws_session_name}"
        external_id = "OPS_TF"
    }
}

# Vpc
module "vpc-cloudops-test" {
    source = "../../../../modules/network/vpc"
  
    vpc_cidr = "${var.vpc_cidr}"
    vpc_tag_name = "${var.vpc_tag_name}"
}

# Routetables
module "route-table-cloudops-test-public" {
    source = "../../../../modules/network/route-table-public"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    route_table_name = "shared-public-rtb"
}

module "route-table-cloudops-test-private" {
    source = "../../../../modules/network/route-table-private"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    route_table_name = "shared-private-rtb"
}

module "route-table-cloudops-test-protected" {
    source = "../../../../modules/network/route-table-private"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    route_table_name = "shared-protected-rtb"
}

# Subnets
module "subnet-cloudops-test-public-a" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_public_a_cidr}"
    subnet_tag_name = "subnet-public-a"
    subnet_az = "ap-southeast-2a"
}
module "subnet-cloudops-test-public-b" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_public_b_cidr}"
    subnet_tag_name = "subnet-public-b"
    subnet_az = "ap-southeast-2b"
}
module "subnet-cloudops-test-public-c" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_public_c_cidr}"
    subnet_tag_name = "subnet-public-c"
    subnet_az = "ap-southeast-2c"
}


# Subnet / Routetable association
resource "aws_route_table_association" "rtb-association-subnet-public-a" {
	subnet_id = "${module.subnet-cloudops-test-public-a.subnet_id}"
	route_table_id = "${module.route-table-cloudops-test-public.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-public-b" {
	subnet_id = "${module.subnet-cloudops-test-public-b.subnet_id}"
	route_table_id = "${module.route-table-cloudops-test-public.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-public-c" {
	subnet_id = "${module.subnet-cloudops-test-public-c.subnet_id}"
	route_table_id = "${module.route-table-cloudops-test-public.route_table_id}"
}

# Nat gw