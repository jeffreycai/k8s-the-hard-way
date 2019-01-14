# worker server
resource "aws_instance" "ks-wk-1" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.sg-ks-wk.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-wk1"
#    }
}

resource "aws_instance" "ks-wk-2" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-b.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.sg-ks-wk.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-wk2"
#    }
}

resource "aws_security_group" "sg-ks-wk" {
    name = "cloudops-test-ks-wk"
    vpc_id = "${data.aws_vpc.vpc-cloudops-test.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
            "${var.myip_public}",
            "${var.myip_private}"
        ]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.myip_public}",
            "${var.myip_private}"
        ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


