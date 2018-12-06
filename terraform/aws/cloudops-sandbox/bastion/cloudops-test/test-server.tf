## A test private server
#resource "aws_instance" "test-instance" {
#    ami = "${var.bastion_ami}"
#    instance_type = "t2.micro"
#    iam_instance_profile = "${aws_iam_instance_profile.test-profile.id}"
#    subnet_id = "${data.aws_subnet.subnet-cloudops-test-private-a.id}"
#    associate_public_ip_address = false
#    key_name = "${var.bastion_key_name}"
#    vpc_security_group_ids  = [
#        "${data.aws_security_group.sg-private-layer.id}",
#        "${aws_security_group.sg-bastion.id}"
#    ]
#
#    tags {
#        Name = "cloudops-sandbox-test-tst"
#    }
#}
#
## Test iam role
#resource "aws_iam_role" "test-role" {
#    name = "cloudops-sandbox-test-ec2-role"
#
#    assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": {
#    "Effect": "Allow",
#    "Principal": {"Service": "ec2.amazonaws.com"},
#    "Action": "sts:AssumeRole"
#  }
#}
#EOF
#
#}
#
#resource "aws_iam_instance_profile" "test-profile" {
#  name = "cloudops-sandbox-test-iam-profile"
#  role = "${aws_iam_role.test-role.name}"
#}
#
#resource "aws_iam_policy" "test-policy" {
#  name = "cloudops-sandbox-test-policy"
#  path = "/"
#
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": [
#                "s3:ListAllMyBuckets",
#                "s3:GetBucketLocation"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Effect": "Allow",
#            "Action": "s3:ListBucket",
#            "Resource": "arn:aws:s3:::<BUCKET-NAME>",
#            "Condition": {
#                "StringLike": {
#                    "s3:prefix": [
#                        ""
#                    ]
#                }
#            }
#        }
#    ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy_attachment" "test-attach" {
#  role       = "${aws_iam_role.test-role.name}"
#  policy_arn = "${aws_iam_policy.test-policy.arn}"
#}