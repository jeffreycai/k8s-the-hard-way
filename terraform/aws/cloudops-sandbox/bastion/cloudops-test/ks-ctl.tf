# control server
resource "aws_instance" "ks-ctl-1" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}"
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
        "${data.aws_security_group.sg-public-layer.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-ctl2"
#    }
}

