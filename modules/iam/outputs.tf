output "rds_monitoring_role_name" {
  description = "value of the rds monitoring role name"
  value       = aws_iam_role.rds_monitoring_role.name
}

output "rds_monitoring_role_arn" {
  description = "value of the rds monitoring role arn"
  value       = aws_iam_role.rds_monitoring_role.arn
}


output "ec2_instance_profile" {
  description = "value of the ec2 instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}