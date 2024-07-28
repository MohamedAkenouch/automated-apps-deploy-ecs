variable "region" {
  description = "AWS region to deploy the resources."
  type        = string
  default     = "us-west-2"
}

variable "app" {
  description = "App name."
  type        = string
  default     = "app"
}

variable "environment" {
  description = "AWS environment to deploy the resources."
  type        = string
  default     = "dev"
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "path_based_routes" {
  description = "List of path-based routes for the ALB."
  type        = list(string)
  default     = ["/api/*", "/static/*"]
}

variable "cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
  default     = "app-ecs-cluster"
}

variable "alb_name" {
  description = "Name of the ALB."
  type        = string
  default     = "app-alb"
}

variable "services" {
  type = list(object({
    name                             = string
    health_check_path                = string
    health_check_interval            = number
    health_check_timeout             = number
    health_check_healthy_threshold   = number
    health_check_unhealthy_threshold = number
    family                           = string
    cpu                              = number
    memory                           = number
    container_name                   = string
    container_image                  = string
    desired_count                    = number
    path_patterns                    = list(string)
  }))
  default = [
    {
      name                             = "app"
      health_check_path                = "/app/health"
      health_check_interval            = 30
      health_check_timeout             = 5
      health_check_healthy_threshold   = 3
      health_check_unhealthy_threshold = 3
      family                           = "app-task-family"
      cpu                              = 256
      memory                           = 512
      container_name                   = "app-container"
      container_image                  = "nginx"
      desired_count                    = 2
      path_patterns                    = ["/*"]
    }
  ]
}
