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
resource "aws_route_table_association" "rtb-association-subnet-protected-a" {
    subnet_id = "${module.subnet-cloudops-test-protected-a.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-protected.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-protected-b" {
    subnet_id = "${module.subnet-cloudops-test-protected-b.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-protected.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-protected-c" {
    subnet_id = "${module.subnet-cloudops-test-protected-c.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-protected.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-private-a" {
    subnet_id = "${module.subnet-cloudops-test-private-a.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-private.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-private-b" {
    subnet_id = "${module.subnet-cloudops-test-private-b.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-private.route_table_id}"
}
resource "aws_route_table_association" "rtb-association-subnet-private-c" {
    subnet_id = "${module.subnet-cloudops-test-private-c.subnet_id}"
    route_table_id = "${module.route-table-cloudops-test-private.route_table_id}"
}

# Nat gw routes
resource "aws_route" "route-nat-gw-private" {
    route_table_id = "${module.route-table-cloudops-test-private.route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id  = "${module.nat-gw-cloudops-test-private.nat_gateway_id}"
}
resource "aws_route" "route-nat-gw-protected" {
    route_table_id = "${module.route-table-cloudops-test-protected.route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id  = "${module.nat-gw-cloudops-test-protected.nat_gateway_id}"
}