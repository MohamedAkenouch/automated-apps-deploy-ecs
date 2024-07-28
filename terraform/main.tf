terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = var.cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = var.alb_name
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
}

module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "alb_listener" {
  for_each            = { for sg in var.services : sg.name => sg }
  source              = "./modules/lb_listener"
  load_balancer_arn   = module.alb.alb_arn
  port                = 80
  protocol            = "HTTP"
  default_action_type = "fixed-response"
  error_message       = "The requested resource was not found."
  error_status_code   = "404"
  target_group_arn   = module.target_groups[each.key].target_group_arn
  action_type        = "forward"
  host_header_values = ["${var.app}.${var.environment}.com"]
  path_patterns      = each.value.path_patterns
  priority           = 1
}

module "target_groups" {
  for_each = { for sg in var.services : sg.name => sg }

  source = "./modules/target_group"

  name                             = "${var.app}-${each.value.name}-target-group"
  port                             = 80
  protocol                         = "HTTP"
  vpc_id                           = module.vpc.vpc_id
  health_check_path                = each.value.health_check_path
  health_check_interval            = each.value.health_check_interval
  health_check_timeout             = each.value.health_check_timeout
  health_check_healthy_threshold   = each.value.health_check_healthy_threshold
  health_check_unhealthy_threshold = each.value.health_check_unhealthy_threshold
}

module "ecs_services" {
  for_each = { for sg in var.services : sg.name => sg }

  source = "./modules/ecs_service"


  family                   = each.value.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  container_definitions = [{
    name      = each.value.container_name
    image     = each.value.container_image
    cpu       = each.value.cpu
    memory    = each.value.memory
    essential = true
    portMappings  = [{
      containerPort = 80
      hostPort      = 80
    }]
  }]
  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  service_name       = "${var.app}-${var.environment}-${each.value.name}-service"
  cluster_id         = module.ecs_cluster.cluster_id
  desired_count      = each.value.desired_count
  launch_type        = "FARGATE"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [aws_security_group.ecs_service_sg.id]
  target_group_arn   = module.target_groups[each.key].target_group_arn
  container_name     = each.value.container_name
  container_port     = 80
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow all inbound and outbound traffic for ECS service"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
