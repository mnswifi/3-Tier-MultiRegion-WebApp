output "rds_monitoring_role_name" {
  description = "value of the rds monitoring role name"
  value       = aws_iam_role.rds_monitoring_role.name
}

output "rds_monitoring_role_arn" {
  description = "value of the rds monitoring role arn"
  value       = aws_iam_role.rds_monitoring_role.arn
}
