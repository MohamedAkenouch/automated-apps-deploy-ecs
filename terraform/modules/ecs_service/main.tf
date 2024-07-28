resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode(var.container_definitions)

  execution_role_arn = var.execution_role_arn

  tags = {
    Name = var.family
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  tags = {
    Name = var.service_name
  }
}
