variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "env_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "target_port" {
  description = "Port for forwarding to target group (App port)"
  type        = number
  default     = 80
}

