variable "alb_name" {
  description = "The ID of the VPC where the ALB is deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB is deployed."
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the ALB."
  type        = list(string)
}
