# control server
resource "aws_security_group" "ks-ctl-sg" {
    name        = "ks-ctl-sg"
    description = "K8s ctl sg"
    vpc_id      = "${data.aws_vpc.vpc-cloudops-test.id}"
  
    ingress {
        from_port   = 2379
        to_port     = 2380
        protocol    = "tcp"
        self        = true
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = ["${aws_security_group.ks-lb-sg.id}"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["${aws_security_group.ks-lb-sg.id}"]
    }

}


resource "aws_instance" "ks-ctl-1" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.ks-ctl-sg.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-ctl1"
#    }
}

resource "aws_instance" "ks-ctl-2" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-b.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.ks-ctl-sg.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-ctl2"
#    }
}


