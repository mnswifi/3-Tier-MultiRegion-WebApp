#publicly accessible
variable "publicly_accessible" {
  description = "value for publicly accessible"
  type        = bool
  default     = false
}

#allocated storage
variable "allocated_storage" {
  description = "value for allocated storage"
  type        = number
}

#storage type
variable "storage_type" {
  description = "value for storage type"
  type        = string
}

#engine
variable "engine" {
  description = "value for engine"
  type        = string
}

#engine version
variable "engine_version" {
  description = "value for engine version"
  type        = string
}

#instance class
variable "instance_class" {
  description = "value for instance class"
  type        = string
}

#identifier
variable "db_identifier" {
  description = "value for identifier"
  type        = string
}

#username
variable "db_username" {
  description = "value for username"
  type        = string
  sensitive   = true
}

#password
variable "db_password" {
  description = "value for password"
  type        = string
  sensitive   = true
}

# kms key id - primary key
variable "primary_kms_key_arn" {
  description = "value for kms key id"
  type        = string
}

# kms key id - backup key
variable "backup_kms_key_arn" {
  description = "value for kms key id"
  type        = string
}


# rds monitoring role
variable "rds_monitoring_role_arn" {
  description = "value for rds monitoring role"
  type        = string
}

# db sg ids
variable "rds_sg_id" {
  description = "The security group id for db tier"
  type        = string
}

variable "db_subnet_ids" {
  description = "The db subnet ids"
  type        = list(string)
}

variable "backup_region" {
  description = "AWS provider alias for cross region RDS backup"
  type        = string
}


variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
}


variable "skip_final_snapshot_replica" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted for replica."
  type        = bool
}

variable "name_prefix" {
  description = "The prefix for the name of the resources"
  type        = string
  default     = "webapp"
}