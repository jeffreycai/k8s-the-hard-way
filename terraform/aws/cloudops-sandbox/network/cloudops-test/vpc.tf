# Vpc
module "vpc-cloudops-test" {
    source = "../../../../modules/network/vpc"
  
    vpc_cidr = "${var.vpc_cidr}"
    vpc_tag_name = "${var.vpc_tag_name}"
}
