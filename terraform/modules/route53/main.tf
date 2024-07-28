resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "app_dev" {
  zone_id = aws_route53_zone.main.id
  name    = "app.dev.com"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_staging" {
  zone_id = aws_route53_zone.main.id
  name    = "app.staging.com"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_prod" {
  zone_id = aws_route53_zone.main.id
  name    = "app.prod.com"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
