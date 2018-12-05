variable "vpc_id" {}
variable "route_table_name" {}

# Internet GW
resource "aws_internet_gateway" "internet-gw-generic" {
    vpc_id = "${var.vpc_id}"

    tags {
        Name = "internet-gw-generic"
    }
}

# Route table
resource "aws_route_table" "route-table-generic" {
    vpc_id = "${var.vpc_id}"    
    tags {
        Name = "route-table-${var.route_table_name}"
    }
}

# Route
resource "aws_route" "route-internet-gw" {
    route_table_id = "${aws_route_table.route-table-generic.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id  = "${aws_internet_gateway.internet-gw-generic.id}"
}
