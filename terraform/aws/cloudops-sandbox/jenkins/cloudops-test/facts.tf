# Vpc
data "aws_vpc" "vpc-cloudops-test" {
    tags = {Name = "${var.vpc_tag_name}"}
}

# Subnets
data "aws_subnet" "subnet-cloudops-test-public-a" {
    tags = {Name = "subnet-public-a"}
}
data "aws_subnet" "subnet-cloudops-test-public-b" {
    tags = {Name = "subnet-public-b"}
}
data "aws_subnet" "subnet-cloudops-test-public-c" {
    tags = {Name = "subnet-public-c"}
}
data "aws_subnet" "subnet-cloudops-test-protected-a" {
    tags = {Name = "subnet-protected-a"}
}
data "aws_subnet" "subnet-cloudops-test-protected-b" {
    tags = {Name = "subnet-protected-b"}
}
data "aws_subnet" "subnet-cloudops-test-protected-c" {
    tags = {Name = "subnet-protected-c"}
}
data "aws_subnet" "subnet-cloudops-test-private-a" {
    tags = {Name = "subnet-private-a"}
}
data "aws_subnet" "subnet-cloudops-test-private-b" {
    tags = {Name = "subnet-private-b"}
}
data "aws_subnet" "subnet-cloudops-test-private-c" {
    tags = {Name = "subnet-private-c"}
}

# Security group
data "aws_security_group" "sg-public-layer" {
  name = "public-layer"
}
data "aws_security_group" "sg-protected-layer" {
  name = "protected-layer"
}
data "aws_security_group" "sg-private-layer" {
  name = "private-layer"
}
