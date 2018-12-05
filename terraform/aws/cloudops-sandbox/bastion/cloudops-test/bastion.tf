# Bastion server
resource "aws_instance" "web" {
    ami = "${var.bastion_ami}"
    instance_type = "t2.micro"
    subnet_id = "${data.aws_subnet.subnet-cloudops-test-public-a.id}"
    associate_public_ip_address = true
    key_name = "${var.bastion_key_name}"

    tags {
        Name = "cloudops-sandbox-test-btn"
    }
}