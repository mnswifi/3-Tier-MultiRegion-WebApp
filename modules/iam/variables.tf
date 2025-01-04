
variable "role_name" {
  description = "The name of the role"
  type        = string
  default     = "rds-monitoring-role"
}

variable "region" {
  description = "The region"
  type        = string
}