###################################
#           VPC                   #
###################################

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  env_name        = var.env_name
}

###################################
#           ALB                   #
###################################

module "alb" {
  source      = "../../modules/alb"
  vpc_id      = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  env_name    = var.env_name
}

###################################
#         Compute                 #
###################################

module "compute" {
  source               = "../../modules/compute"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnets
  env_name             = var.env_name
  key_name             = var.key_name
  instance_type        = var.instance_type
  user_data            = file("../../scripts/user_data.sh")
  instance_profile_name = module.iam.instance_profile_name
  alb_target_group_arn  = module.alb.target_group_arn
  alb_sg_id = module.alb.alb_sg_id
 
}

###################################
#           RDS                   #
###################################

module "rds" {
  source              = "../../modules/rds"
  env_name            = var.env_name
  vpc_id              = module.vpc.vpc_id
  private_subnets_ids  = module.vpc.private_subnets
  web_sg_id           = module.compute.web_sg_id
  iam_role_arn        = module.iam.rds_role_arn
}

###################################
#           WAF                   #
###################################

module "waf" {
  source    = "../../modules/waf"
  env_name  = var.env_name
  alb_arn   = module.alb.alb_arn
}

###################################
#           IAM                   #
###################################

module "iam" {
  source             = "../../modules/iam"
  env_name           = var.env_name
  backup_bucket_name = module.s3.backup_bucket_name
}

###################################
#           S3                    #
###################################

module "s3" {
  source   = "../../modules/s3"
  env_name = var.env_name
}

###################################
#        Monitoring               #
###################################

module "monitoring" {
  source      = "../../modules/monitoring"
  env_name    = var.env_name
  asg_name    = module.compute.asg_name
  alert_email = var.alert_email
}

