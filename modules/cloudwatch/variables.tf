variable "autoscaling_group_name" {
  description = "The name of the autoscaling group"
  type        = string
}

variable "autoscaling_policy_up_arn" {
  description = "The name of the autoscaling policy for scaling up"
  type        = string
}

variable "autoscaling_policy_down_arn" {
  description = "The name of the autoscaling policy for scaling down"
  type        = string
}