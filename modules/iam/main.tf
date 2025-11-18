########################################
# IAM ROLES & POLICIES MODULE
# Includes: EC2 Role + RDS-to-S3 Role
########################################

########################################
# EC2 ROLE - For CloudWatch & SSM access
########################################

# Policy document for EC2 permissions
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*"
    ]
    resources = ["*"]
  }
}

# IAM Policy for EC2
resource "aws_iam_policy" "ec2_custom_policy" {
  name        = "ec2-policy-${var.env_name}"
  description = "Custom EC2 policy for ${var.env_name}"
  policy      = data.aws_iam_policy_document.ec2_policy.json
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-${var.env_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.env_name
    ManagedBy   = "Terraform"
  }
}

# Attach EC2 policy to the role
resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_custom_policy.arn
}

# Create instance profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-${var.env_name}"
  role = aws_iam_role.ec2_role.name
}

###########################################
# RDS ROLE - Allow access to S3 for backups
###########################################

# Policy document for RDS to S3 access
data "aws_iam_policy_document" "rds_s3_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      "arn:aws:s3:::${var.backup_bucket_name}",
      "arn:aws:s3:::${var.backup_bucket_name}/*"
    ]

  }
}

# IAM Policy for RDS
resource "aws_iam_policy" "rds_s3_policy" {
  name        = "rds-s3-policy-${var.env_name}"
  description = "Allow RDS to access S3 for backups"
  policy      = data.aws_iam_policy_document.rds_s3_policy.json
}


# IAM Role for RDS
resource "aws_iam_role" "rds_role" {
  name = "rds-role-${var.env_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.env_name
    ManagedBy   = "Terraform"
  }
}

# Attach RDS S3 policy to the role
resource "aws_iam_role_policy_attachment" "attach_rds_policy" {
  role       = aws_iam_role.rds_role.name
  policy_arn = aws_iam_policy.rds_s3_policy.arn
}






