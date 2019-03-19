# lb server
resource "aws_security_group" "ks-lb-sg" {
    name        = "ks-lb-sg"
    description = "K8s lb sg"
    vpc_id      = "${data.aws_vpc.vpc-cloudops-test.id}"
  
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ks-lb-1" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}"
    ]

    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}",
        "${aws_security_group.ks-lb-sg.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-lb"
#    }
}
