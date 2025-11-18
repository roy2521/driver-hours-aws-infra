variable "vpc_id" {type = string}
variable "private_subnet_ids" {type = list(string)}
variable "env_name" {type = string}
variable "key_name" {type = string}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "user_data" {
  type        = string
  default     = ""
}

variable "desired_capacity" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 3
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "alb_target_group_arn" {
  description = "Optional target group ARN for ALB registration"
  type        = string
  default     = ""
}

variable "instance_profile_name" {
  type        = string
  default     = null
}
variable "alb_sg_id" {
  description = "Security Group ID of the ALB"
  type        = string
}
