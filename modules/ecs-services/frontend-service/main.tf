################################################################################
# App Service - Main Application
################################################################################
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.environment}/frontend"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name    = "${var.environment}-frontend-logs"
    Service = "frontend"
  })
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.project_name}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      # TODO DEFINE SSM PARAMETER VALUES HERE IF NEEDED BASED ON THE BELOW EXAMPLE
      # REPLACE VALUES ENCLOSED IN <>
      # secrets = [
      #   {
      #     "name" : "<ENV_VAR_NAME>"",
      #     "valueFrom" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}-<SSM_PARAMETER_NAME>"
      #   }
      # ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name    = "${var.project_name}-frontend-task-definition"
    Service = "frontend"
  })
}

resource "aws_ecs_service" "frontend" {
  name            = "${var.project_name}-frontend"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_sg_frontend.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.load_balancer_target_group_arn
    container_name   = "frontend"
    container_port   = var.container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  enable_execute_command  = true
  enable_ecs_managed_tags = false
  propagate_tags          = "TASK_DEFINITION"

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  depends_on = [
    aws_cloudwatch_log_group.frontend,
    aws_ecs_task_definition.frontend
  ]

  tags = merge(var.tags, {
    Name    = "${var.project_name}-frontend"
    Service = "frontend"
  })

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
}

################################################################################
# Security Group for ECS Service
################################################################################
resource "aws_security_group" "ecs_sg_frontend" {
  name        = "ecs-frontend-sg"
  description = "Sets inbound traffic and outbound traffic for ECS app service"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-frontend-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.ecs_sg_frontend.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ecs_sg_frontend.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_sg_frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

