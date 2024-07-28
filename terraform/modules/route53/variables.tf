variable "domain_name" {
  description = "The domain name for the hosted zone."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB."
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB."
  type        = string
}