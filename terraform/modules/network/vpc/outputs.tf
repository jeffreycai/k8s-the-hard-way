output "vpc_cidr" { value = "${aws_vpc.vpc-generic.cidr_block}" }
output "vpc_id" { value = "${aws_vpc.vpc-generic.id}" }