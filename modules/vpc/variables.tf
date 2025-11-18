variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets CIDRs"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets CIDRs"
}

variable "env_name" {
  type        = string
  description = "Environment name"
}

