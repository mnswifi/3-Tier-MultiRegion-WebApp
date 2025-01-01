variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}


variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs"
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

variable "user_data" {
  description = "The user data for launching web portal"
  type        = any
}

variable "health_check_grace_period" {
  description = "The amount of time, in seconds, that Auto Scaling waits before checking the health status of an EC2 instance that has come into service"
  type        = number
  default     = 300
}


variable "associate_public_ip_address" {
  description = "Associate public IP address"
  type        = bool
  default     = false
}