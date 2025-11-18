variable "region" { type = string}
variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "env_name" {type = string }
variable "instance_type" { type = string }
variable "key_name"  { type = string }
