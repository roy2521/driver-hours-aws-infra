output "backup_bucket_name" {
  description = "S3 bucket name"
  value       = module.rds_backup_bucket.s3_bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.rds_backup_bucket.s3_bucket_arn
}

