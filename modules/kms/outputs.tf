output "primary_kms_key_arn" {
  description = "value of the primary kms key arn"
  value       = aws_kms_key.primary_kms_key.arn
}

output "backup_kms_key_arn" {
  description = "value of the backup kms key arn"
  value       = aws_kms_key.backup_kms_key.arn
}
