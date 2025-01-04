############################# VPC #########################################
module "vpc" {
  source               = "../../modules/vpc"
  cidr_block           = "10.0.0.0/16"
  egress               = var.egress
  ingress              = var.ingress
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Key   = "Name"
    Value = "dev-vpc"
  }
  create_db_subnet = var.create_db_subnet
}

##################################### Elastic Load Balancer ##########################
module "elb" {
  source                     = "../../modules/elb"
  name                       = var.name
  load_balancer_type         = var.load_balancer_type
  internal                   = var.internal
  listener                   = var.listener
  vpc_id                     = module.vpc.webapp_vpc_id
  target_grp                 = var.target_grp
  security_group_ids         = [module.vpc.dev_elb_sg]
  asg_id                     = module.asg.asg_id
  subnet_ids                 = module.vpc.webapp_public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Key   = "Name"
    Value = "dev-elb"
  }
}

##################################### Auto Scaling Group #################################
module "asg" {
  source               = "../../modules/asg"
  depends_on           = [module.ssm]
  desired_capacity     = var.desired_capacity
  subnet_ids           = module.vpc.webapp_private_subnet_ids
  max_size             = var.max_size
  min_size             = var.min_size
  health_check_type    = var.health_check_type
  ami_id               = data.aws_ami.ubuntu.id
  security_group_ids   = [module.vpc.webapp_sg_ids]
  instance_type        = var.instance_type
  iam_instance_profile = module.iam.ec2_instance_profile
  user_data            = base64encode(file("user_data.sh"))
}

##################################### RDS #################################
module "rds" {
  source                      = "../../modules/Rds"
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_identifier               = var.db_identifier
  db_username                 = var.db_username
  db_password                 = var.db_password
  primary_kms_key_arn         = module.kms.primary_kms_key_arn
  backup_kms_key_arn          = module.kms.backup_kms_key_arn
  rds_monitoring_role_arn     = module.iam.rds_monitoring_role_arn
  db_subnet_ids               = module.vpc.db_subnet_ids
  backup_region               = var.backup_region
  rds_sg_id                   = module.vpc.rds_sg_id
  multi_az                    = var.multi_az
  skip_final_snapshot         = var.skip_final_snapshot
  skip_final_snapshot_replica = var.skip_final_snapshot_replica
}


############################### CloudWatch ########################################  
# Cloudwatch Alarm Trigger
module "cloudwatch" {
  source                      = "../../modules/cloudwatch"
  autoscaling_group_name      = module.asg.autoscaling_group_name
  autoscaling_policy_up_arn   = module.asg.autoscaling_policy_up_arn
  autoscaling_policy_down_arn = module.asg.autoscaling_policy_down_arn
}


############################### KMS ########################################
module "kms" {
  source        = "../../modules/kms"
  backup_region = var.backup_region
}


############################### IAM ########################################
module "iam" {
  source = "../../modules/iam"
  region = var.region
}


############################### SSM ########################################
module "ssm" {
  source       = "../../modules/ssm"
  rds_endpoint = module.rds.rds_endpoint
  db_password  = var.db_password
  db_username  = var.db_username
}

