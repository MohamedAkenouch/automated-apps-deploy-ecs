resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type = var.default_action_type

    fixed_response {
      content_type = "text/plain"
      message_body = var.error_message
      status_code  = var.error_status_code
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn     = aws_lb_listener.this.arn
  priority         = var.priority

  action {
    type = var.action_type
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = var.path_patterns
    }
  }

  condition {
    host_header {
      values = var.host_header_values
    }
  }

}