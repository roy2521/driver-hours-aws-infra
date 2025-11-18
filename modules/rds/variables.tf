variable "env_name" {}
variable "vpc_id" {}
variable "private_subnets_ids" {type = list(string)}
variable "web_sg_id" {description = "Security group ID of EC2/Compute"}
variable "db_name" {default = "truckapp"}
variable "db_username" {default = "admin"}
variable "db_password" {default = "Admin123!"}
variable "db_port" {default = 3306}
variable "iam_role_arn" {}

