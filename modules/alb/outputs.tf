output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID of the ALB"
  value       = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  description = "Target Group ARN for attaching to ASG"
  value       = aws_lb_target_group.web_tg.arn
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.web_alb.arn
}

