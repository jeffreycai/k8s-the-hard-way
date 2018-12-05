# Nat gw
module "nat-gw-cloudops-test-protected" {
    source = "../../../../modules/network/nat"

    subnet_id = "${module.subnet-cloudops-test-public-a.subnet_id}"
}
module "nat-gw-cloudops-test-private" {
    source = "../../../../modules/network/nat"

    subnet_id = "${module.subnet-cloudops-test-public-b.subnet_id}"
}