variable "family" {
  description = "The family of the ECS task definition."
  type        = string
}

variable "network_mode" {
  description = "The network mode of the ECS task definition."
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "The launch types required by the ECS task definition."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "The number of CPU units used by the ECS task."
  type        = string
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the ECS task."
  type        = string
}

variable "container_definitions" {
  description = "A list of container definitions for the task."
  type        = list(object({
    name      = string
    image     = string
    cpu       = number
    memory    = number
    essential = bool
    portMappings = list(object({
      containerPort = number
      hostPort      = number
    }))
  }))
}

variable "execution_role_arn" {
  description = "The ARN of the task execution role."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "cluster_id" {
  description = "The ID of the ECS cluster."
  type        = string
}

variable "desired_count" {
  description = "The number of tasks to run."
  type        = number
}

variable "launch_type" {
  description = "The launch type of the service (e.g., EC2 or FARGATE)."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets for the ECS service."
  type        = list(string)
}

variable "security_group_ids" {
  description = "The IDs of the security groups for the ECS service."
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group."
  type        = string
}

variable "container_name" {
  description = "The name of the container in the task definition to associate with the target group."
  type        = string
}

variable "container_port" {
  description = "The port on the container to associate with the target group."
  type        = number
}
