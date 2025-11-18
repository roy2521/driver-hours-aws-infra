variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
}

variable "asg_name" {
  description = "Auto Scaling group name to monitor"
}

variable "alert_email" {
  description = "Email address for alert notifications"
}

