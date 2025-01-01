######################## Cloudwatch Alarm Trigger ############################
# Scale up the instances when CPU utilization is greater than 70%
resource "aws_cloudwatch_metric_alarm" "webapp_asg_alarm_up" {
  alarm_name          = "webapp-asg-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 instance CPU utilization"
  alarm_actions       = [var.autoscaling_policy_up_arn]
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
  actions_enabled = true
}

# Scale down the instances when CPU utilization is less than 30%
resource "aws_cloudwatch_metric_alarm" "webapp_asg_alarm_down" {
  alarm_name          = "webapp-asg-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors ec2 instance CPU utilization"
  alarm_actions       = [var.autoscaling_policy_down_arn]
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
  actions_enabled = true
}


