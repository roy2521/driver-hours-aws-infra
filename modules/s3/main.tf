####################################################
# RDS Backup Bucket AWS S3 Module
####################################################

# Create unique suffix
resource "random_id" "suffix" {
  byte_length = 4
}

module "rds_backup_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "rds-backup-${var.env_name}-${random_id.suffix.hex}"

  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Enable Versioning
  versioning = {
    enabled = true
  }

  # Enable Default Encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }


  # Lifecycle rules to clean old versions
  lifecycle_rule = [
    {
      id      = "expire-old-versions"
      enabled = true
      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  tags = {
    Name        = "rds-backup-${var.env_name}"
    Environment = var.env_name
    ManagedBy   = "Terraform"
  }
}

