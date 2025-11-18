output "instance_profile_name" {
  description = "Name of the IAM Instance Profile for EC2"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "rds_role_arn" {
  description = "ARN of the IAM Role for RDS to S3 access"
  value       = aws_iam_role.rds_role.arn
}
