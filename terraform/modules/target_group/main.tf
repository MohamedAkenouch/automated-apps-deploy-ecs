resource "aws_lb_target_group" "alb_target_group" {
  name     = var.name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = {
    Name = var.name
  }
}
