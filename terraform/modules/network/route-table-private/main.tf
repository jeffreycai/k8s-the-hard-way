variable "vpc_id" {}
variable "route_table_name" {}

# Route table
resource "aws_route_table" "route-table-generic" {
    vpc_id = "${var.vpc_id}"    
    tags {
        Name = "route-table-${var.route_table_name}"
    }
}
