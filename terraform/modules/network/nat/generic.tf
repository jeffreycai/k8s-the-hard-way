variable "subnet_id" {}
variable "route_table_id" {}

resource "aws_eip" "route-table-generic-eip" {
    vpc = true
}

resource "aws_net_gateway" "net-gw-generic" {
    allocation_id = "${aws_eip.route-table-generic-eip.id}"
    subnet_id = "${var.subnet_id}"
}

resource "aws_route" "route-net-gw-generic" {
    route_table_id = "${var.route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id  = "${aws_nat_gateway.net-gw-generic.id}"
}

output "nat_gateway_id" { value = "${aws_nat_gateway.net-gw-generic.id}" }
output "nat_gateway_public_ip" { value = "${aws_eip.route-table-generic-eip.public_ip}" }