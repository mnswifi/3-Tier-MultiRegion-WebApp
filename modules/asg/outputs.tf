output "asg_id" {
  description = "The Auto Scaling Group id"
  value       = aws_autoscaling_group.webapp_asg.id
}

output "autoscaling_group_name" {
  description = "The Auto Scaling Group name"
  value       = aws_autoscaling_group.webapp_asg.name
}

output "autoscaling_policy_up_arn" {
  description = "The ARN of the Auto Scaling Policy for scaling up"
  value       = aws_autoscaling_policy.webapp_asg_step_scale_up.arn
}

output "autoscaling_policy_down_arn" {
  description = "The ARN of the Auto Scaling Policy for scaling down"
  value       = aws_autoscaling_policy.webapp_asg_step_scale_down.arn
}