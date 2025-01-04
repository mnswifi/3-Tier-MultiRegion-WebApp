
variable "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  sensitive   = true
}

variable "ssm_path" {
  description = "The path for the SSM parameters"
  type        = string
  default     = "/webapp/rds"
}

