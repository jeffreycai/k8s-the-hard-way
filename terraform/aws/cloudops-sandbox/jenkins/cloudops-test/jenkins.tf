## Bastion server
resource "aws_instance" "jenkins_master" {
    ami = "${var.base_ami}"
    instance_type = "t3.medium"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.base_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.sg-jenkins_master.id}"
    ]

    tags {
        Name = "cloudops-sandbox-test-jks"
    }
}

resource "aws_security_group" "sg-jenkins_master" {
    name = "test-jks"
    vpc_id = "${data.aws_vpc.vpc-cloudops-test.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.myip_public}"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["${var.myip_public}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


