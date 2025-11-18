output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.web_db.endpoint
}

output "rds_sg_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds_sg.id
}

