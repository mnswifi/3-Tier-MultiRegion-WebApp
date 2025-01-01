# Create a KMS key for Primary RDS encryption
resource "aws_kms_key" "primary_kms_key" {
  description             = "KMS Key for RDS Encryption in Primary Region"
  deletion_window_in_days = 30

  tags = {
    Name = "MyKMSKey"
  }
}

# Create a KMS key for Cross Region RDS Backup encryption
resource "aws_kms_key" "backup_kms_key" {
  description             = "KMS Key for RDS Encryption in Backup Region"
  deletion_window_in_days = 30

  tags = {
    Name = "MyKMSKey"
  }

  provider = aws.backup_provider
}


