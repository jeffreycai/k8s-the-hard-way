# lb server
resource "aws_instance" "ks-lb-1" {
    ami = "${var.ks_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"
    vpc_security_group_ids  = [
        "${data.aws_security_group.sg-public-layer.id}"
    ]

#    tags {
#        Name = "cloudops-sandbox-test-lb"
#    }
}
