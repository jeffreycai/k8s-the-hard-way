# Bastion server
resource "aws_instance" "web" {
    ami = "${var.bastion_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.sg-bastion.id}"
    ]

    tags {
        Name = "cloudops-sandbox-test-btn"
    }
}

resource "aws_security_group" "sg-bastion" {
    name = "test-btn"
    vpc_id = "${data.aws_vpc.vpc-cloudops-test.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.myip}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


