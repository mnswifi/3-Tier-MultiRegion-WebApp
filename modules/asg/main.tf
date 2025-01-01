######################## Launch Template ############################
resource "aws_launch_template" "dev_temp" {
  name          = var.launch_configuration_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = var.user_data

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_group_ids
  }
}

######################## Auto Scaling Group ############################
resource "aws_autoscaling_group" "webapp_asg" {
  name                      = "ASG-dev"
  vpc_zone_identifier       = var.subnet_ids
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  force_delete              = true
  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.dev_temp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webApp-instance"
    propagate_at_launch = true
  }
}



######################## Auto Scaling Policy ############################
# Scale up policy
resource "aws_autoscaling_policy" "webapp_asg_step_scale_up" {
  name                   = "webapp-asg-step-scaling-up"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 70
    metric_interval_upper_bound = null
  }
}

# Scale down policy
resource "aws_autoscaling_policy" "webapp_asg_step_scale_down" {
  name                   = "webapp-asg-step-scaling-down"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name

  # Step adjustment for CPU utilization <= 30%
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 30
  }

  # Catch-all Step adjustment for CPU utilization < 30%
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = 30
    metric_interval_upper_bound = null
  }
}

