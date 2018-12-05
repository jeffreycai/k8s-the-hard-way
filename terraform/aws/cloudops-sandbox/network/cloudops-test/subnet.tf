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
module "subnet-cloudops-test-protected-a" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_protected_a_cidr}"
    subnet_tag_name = "subnet-protected-a"
    subnet_az = "ap-southeast-2a"
}
module "subnet-cloudops-test-protected-b" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_protected_b_cidr}"
    subnet_tag_name = "subnet-protected-b"
    subnet_az = "ap-southeast-2b"
}
module "subnet-cloudops-test-protected-c" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_protected_c_cidr}"
    subnet_tag_name = "subnet-protected-c"
    subnet_az = "ap-southeast-2c"
}
module "subnet-cloudops-test-private-a" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_private_a_cidr}"
    subnet_tag_name = "subnet-private-a"
    subnet_az = "ap-southeast-2a"
}
module "subnet-cloudops-test-private-b" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_private_b_cidr}"
    subnet_tag_name = "subnet-private-b"
    subnet_az = "ap-southeast-2b"
}
module "subnet-cloudops-test-private-c" {
    source = "../../../../modules/network/subnet"

    vpc_id = "${module.vpc-cloudops-test.vpc_id}"
    subnet_cidr = "${var.subnet_private_c_cidr}"
    subnet_tag_name = "subnet-private-c"
    subnet_az = "ap-southeast-2c"
}

