variable "subnet_id" {}

resource "aws_eip" "route-table-generic-eip" {
    vpc = true
}

resource "aws_nat_gateway" "nat-gw-generic" {
    allocation_id = "${aws_eip.route-table-generic-eip.id}"
    subnet_id = "${var.subnet_id}"
}

