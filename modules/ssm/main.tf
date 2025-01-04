# SSM Parameters
resource "aws_ssm_parameter" "db_endpoint" {
  name  = "${var.ssm_path}/endpoint"
  type  = "String"
  value = var.rds_endpoint
}

resource "aws_ssm_parameter" "db_username" {
  name  = "${var.ssm_path}/username"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "${var.ssm_path}/password"
  type  = "SecureString"
  value = var.db_password
}

