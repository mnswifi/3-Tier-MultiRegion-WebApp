###################### RDS Instance ######################

resource "aws_db_instance" "primary_db" {
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  identifier        = var.db_identifier
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name



  backup_retention_period   = 7
  backup_window             = "03:00-04:00"
  maintenance_window        = "mon:04:00-mon:04:30"
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.name_prefix}-db"

  # Enable Enhanced Monitoring
  monitoring_interval          = 60
  monitoring_role_arn          = var.rds_monitoring_role_arn
  performance_insights_enabled = true


  # Enable Encryption
  storage_encrypted = true
  kms_key_id        = var.primary_kms_key_arn

  # Associate with parameter group
  parameter_group_name = aws_db_parameter_group.db_pmg.name

  # Enable Multi-AZ deployment for high availability
  multi_az = true

  tags = {
    Name = "${var.name_prefix}-rds"
  }
}

###################### RDS Subnet Group ######################

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.name_prefix} DB Subnet Group"
  }
}

###################### RDS Parameter Group ######################

resource "aws_db_parameter_group" "db_pmg" {
  name   = "${var.name_prefix}-db-pg"
  family = "mysql5.7"

  parameter {
    name  = "connect_timeout"
    value = "15"
  }
}


###################### RDS HA Read Replica ######################
resource "aws_db_instance" "db_replica" {
  replicate_source_db = aws_db_instance.primary_db.identifier
  instance_class      = "db.t3.medium"

  vpc_security_group_ids = [var.rds_sg_id]


  backup_retention_period      = 7
  backup_window                = "03:00-04:00"
  maintenance_window           = "mon:04:00-mon:04:30"
  skip_final_snapshot          = var.skip_final_snapshot_replica
  final_snapshot_identifier    = "${var.name_prefix}-db"
  monitoring_interval          = 60
  monitoring_role_arn          = var.rds_monitoring_role_arn
  performance_insights_enabled = true
  storage_encrypted            = true
  kms_key_id                   = var.primary_kms_key_arn

  parameter_group_name = aws_db_parameter_group.db_pmg.name

  # Enable Multi-AZ deployment for high availability
  multi_az = true

  lifecycle {
    prevent_destroy = false
  }
}


###################### RDS Automated Backups Replication - Cross Region ######################

resource "aws_db_instance_automated_backups_replication" "db_cross_region_backup" {
  source_db_instance_arn = aws_db_instance.primary_db.arn
  retention_period       = 14
  kms_key_id             = var.backup_kms_key_arn

  provider = aws.backup_provider
}




















