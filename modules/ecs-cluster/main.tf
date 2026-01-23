
data "aws_region" "current" {}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.family}-execution-role"

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

resource "aws_iam_role_policy" "ecs_execution_secrets" {
  name = "${var.family}-execution-secrets"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.family}-role"

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

resource "aws_iam_role_policy_attachment" "ecs_task_role_s3_policy" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy" "ecs_exec_policy" {
  count = var.enable_ecs_exec ? 1 : 0
  name  = "${var.family}-ecs-exec"
  role  = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_ecs_cluster" "app_cluster" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      logging = "NONE"
    }
  }
}

resource "aws_ecs_service" "app_service" {
  name                   = var.service_name
  cluster                = aws_ecs_cluster.app_cluster.id
  task_definition        = aws_ecs_task_definition.app.arn
  launch_type            = "FARGATE"
  desired_count          = var.desired_count
  enable_execute_command = var.enable_ecs_exec

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.app, aws_security_group.ecs_sg, aws_iam_role.ecs_execution_role, aws_iam_role.ecs_task_role]
}


resource "aws_ecs_task_definition" "app" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.api_ecr_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = var.environment_variables
      secrets     = var.secrets_from_sm
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.family}/app"
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "app"
        }
      }
    },
    {
      name        = "queue-worker"
      image       = "${var.queue_worker_ecr_repository_url}:latest"
      essential   = true
      environment = var.environment_variables
      secrets     = var.secrets_from_sm
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.family}/queue-worker"
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "queue-worker"
        }
      }
    },
    {
      name        = "scheduler"
      image       = "${var.scheduler_ecr_repository_url}:latest"
      essential   = true
      environment = var.environment_variables
      secrets     = var.secrets_from_sm
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.family}/scheduler"
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "scheduler"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "migration" {
  family                   = "${var.env}-${var.project}-migration"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name        = "migration"
      image       = "${var.api_ecr_repository_url}:latest"
      essential   = true
      entryPoint  = ["/usr/local/bin/php"]
      command     = ["/app/artisan", "migrate", "--force"]
      environment = var.environment_variables
      secrets     = var.secrets_from_sm
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.family}/app"
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "migration"
        }
      }
    }
  ])
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.env}-${var.project}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-ecs-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress" {
  security_group_id = aws_security_group.ecs_sg.id

  referenced_security_group_id = var.whitelist_security_groups[0]
  from_port                    = var.container_port
  ip_protocol                  = "tcp"
  to_port                      = var.container_port
}

# Laravel application logs
resource "aws_cloudwatch_log_group" "laravel_logs" {
  name              = "/ecs/${var.family}/app"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "queu_worker_logs" {
  name              = "/ecs/${var.family}/queue-worker"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "scheduler_logs" {
  name              = "/ecs/${var.family}/scheduler"
  retention_in_days = 90
}