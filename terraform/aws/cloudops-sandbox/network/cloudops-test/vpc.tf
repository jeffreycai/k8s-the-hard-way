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
