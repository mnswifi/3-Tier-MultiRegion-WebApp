variable "cidr_block" {
  description = "The CIDR block"
  type        = string
}

variable "cidr_blocks" {
  description = "The CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "The tags for the VPC"
  type        = map(string)
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "dev_vpc_sg"
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

variable "db_ingress" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
  default = [
    {
      from_port = 3306
      to_port   = 3306
      protocol  = "tcp"
    }
  ]
}

variable "db_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}