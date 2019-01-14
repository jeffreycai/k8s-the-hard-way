# Security groups
resource "aws_security_group" "sg-public-layer" {
    name = "public-layer"
    vpc_id = "${module.vpc-cloudops-test.vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
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

resource "aws_security_group" "sg-protected-layer" {
    name = "protected-layer"
    vpc_id = "${module.vpc-cloudops-test.vpc_id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "${module.subnet-cloudops-test-public-a.subnet_cidr}",
            "${module.subnet-cloudops-test-public-b.subnet_cidr}",
            "${module.subnet-cloudops-test-public-c.subnet_cidr}",
            "${module.subnet-cloudops-test-private-a.subnet_cidr}",
            "${module.subnet-cloudops-test-private-b.subnet_cidr}",
            "${module.subnet-cloudops-test-private-c.subnet_cidr}"
        ],
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = []
    }
}

resource "aws_security_group" "sg-private-layer" {
    name = "private-layer"
    vpc_id = "${module.vpc-cloudops-test.vpc_id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "${module.subnet-cloudops-test-public-a.subnet_cidr}",
            "${module.subnet-cloudops-test-public-b.subnet_cidr}",
            "${module.subnet-cloudops-test-public-c.subnet_cidr}",
            "${module.subnet-cloudops-test-protected-a.subnet_cidr}",
            "${module.subnet-cloudops-test-protected-b.subnet_cidr}",
            "${module.subnet-cloudops-test-protected-c.subnet_cidr}"
        ],
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = []
    }
}