output "nat_gateway_id" { value = "${aws_nat_gateway.nat-gw-generic.id}" }
output "nat_gateway_public_ip" { value = "${aws_eip.route-table-generic-eip.public_ip}" }