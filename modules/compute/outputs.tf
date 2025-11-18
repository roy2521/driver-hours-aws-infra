output "web_sg_id" {
  description = "Application Security Group ID"
  value       = aws_security_group.web_sg.id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web_asg.name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.web_lt.id
}

