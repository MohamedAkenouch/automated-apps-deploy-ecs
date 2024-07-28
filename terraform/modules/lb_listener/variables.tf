variable "load_balancer_arn" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "default_action_type" {
  type = string
}

variable "error_message" {
  type = string
}

variable "error_status_code" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "host_header_values" {
  type        = list(string)
}

variable "path_patterns" {
  type        = list(string)
}

variable "priority" {
  type = number
}

variable "action_type" {
  type = string
}