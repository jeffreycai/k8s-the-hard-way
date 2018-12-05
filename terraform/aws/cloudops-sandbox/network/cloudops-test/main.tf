# AWS Provider
provider "aws" {
    region = "ap-southeast-2"
    profile = "default"
    assume_role {
        role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.assume_role}"
        session_name = "${var.aws_session_name}"
        external_id = "OPS_TF"
    }
}