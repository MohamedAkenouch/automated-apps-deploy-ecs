variable "name" {
  description = "The name of the target group."
  type        = string
}

variable "port" {
  description = "The port on which the targets receive traffic."
  type        = number
}

variable "protocol" {
  description = "The protocol used for routing traffic."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the target group is deployed."
  type        = string
}

variable "health_check_path" {
  description = "The path for health checks."
  type        = string
}

variable "health_check_interval" {
  description = "The interval (in seconds) between health checks."
  type        = number
}

variable "health_check_timeout" {
  description = "The timeout (in seconds) for health checks."
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks required before considering an unhealthy target as healthy."
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks required before considering a healthy target as unhealthy."
  type        = number
}
