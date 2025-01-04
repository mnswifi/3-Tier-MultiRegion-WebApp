####################### VPC ############################

variable "cidr_block" {
  description = "The CIDR block"
  type        = string
}

variable "ingress" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
}

variable "egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "enable_dns_support" {
  description = "If true, enable DNS support in the VPC"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "If true, enable DNS hostnames in the VPC"
  type        = bool
}

# db subnet variables
variable "create_db_subnet" {
  description = "Create RDS DB subnet group"
  default     = false
}


############################ ELB ###############################

variable "name" {
  description = "The name of the ELB"
  type        = string
}

variable "internal" {
  description = "The type of the ELB"
  type        = bool
}


variable "listener" {
  description = "The listener configuration"
  type = list(object({
    lb_port     = number
    lb_protocol = string
  }))
}


variable "target_grp" {
  description = "The listener configuration"
  type = list(object({
    instance_port     = number
    instance_protocol = string
  }))
}


variable "enable_deletion_protection" {
  description = "If true, deletion of the ELB will be protected"
  type        = bool
}


variable "load_balancer_type" {
  description = "The type of load balancer to create"
  type        = string
}

################################## Auto Scaling Group #############################

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "launch_configuration_name" {
  type        = string
  description = "Launch configuration name"
  default     = "webapp-launch-config"
}

variable "min_size" {
  type        = number
  description = "Minimum size"
}

variable "max_size" {
  type        = number
  description = "Maximum size"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity"
}

variable "health_check_type" {
  type        = string
  description = "Health check type"
}

################################## RDS #############################

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

#backup region
variable "backup_region" {
  description = "AWS provider alias for cross region RDS backup"
  type        = string
}

#multi az

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
}

#skip final snapshot
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
}

#skip final snapshot for replica
variable "skip_final_snapshot_replica" {
  description = "Determines whether a final DB snapshot for replica is created before the DB instance is deleted."
  type        = bool
}

variable "region" {
  description = "AWS region"
  type        = string
}