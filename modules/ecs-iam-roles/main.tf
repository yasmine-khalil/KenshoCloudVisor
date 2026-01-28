################################################################################
# ECS Task Execution Role
################################################################################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.env}-${var.project}-ecs-task-execution-role"

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

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-ecs-task-execution-role"
    Type = "ECS-TaskExecution"
  })
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom policy for ECR permissions
resource "aws_iam_role_policy" "ecs_task_execution_ecr_policy" {
  name = "${var.env}-${var.project}-ecs-task-execution-ecr-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

################################################################################
# ECS Task Roles for Services
################################################################################

# FRONTEND Task Role
resource "aws_iam_role" "frontend_task_role" {
  name = "${var.env}-${var.project}-frontend-task-role"

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

  tags = merge(var.tags, {
    Name    = "${var.env}-${var.project}-frontend-task-role"
    Type    = "ECS-Task"
    Service = "frontend"
  })
}

resource "aws_iam_role_policy" "frontend_task_policy" {
  name = "${var.env}-${var.project}-frontend-task-policy"
  role = aws_iam_role.frontend_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = var.frontend_s3_resources
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "servicediscovery:DiscoverInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups",
          "elasticache:DescribeCacheNodes",
          "elasticache:DescribeCacheSecurityGroups",
          "elasticache:DescribeCacheSubnetGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

# Backend Service Task Role
resource "aws_iam_role" "backend_task_role" {
  name = "${var.env}-${var.project}-backend-task-role"

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

  tags = merge(var.tags, {
    Name    = "${var.env}-${var.project}-backend-task-role"
    Type    = "ECS-Task"
    Service = "backend"
  })
}

resource "aws_iam_role_policy" "backend_task_policy" {
  name = "${var.env}-${var.project}-backend-task-policy"
  role = aws_iam_role.backend_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = var.backend_s3_resources
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "servicediscovery:DiscoverInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups",
          "elasticache:DescribeCacheNodes",
          "elasticache:DescribeCacheSecurityGroups",
          "elasticache:DescribeCacheSubnetGroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      }
    ]
  })
}

################################################################################
# S3 cross account access policy for ECS tasks
################################################################################
resource "aws_iam_policy" "lawcloud_s3_cross_account_policy" {
  name        = "LawCloudS3CrossAccountAccess"
  description = "Allows ECS to access the lawcloud-files bucket in Account A"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject" # Include only if you need write access
        ]
        Resource = [
          "arn:aws:s3:::lawcloud-files",
          "arn:aws:s3:::lawcloud-files/*"
        ]
      }
    ]
  })
}

# Attach to ECS Task Roles
resource "aws_iam_role_policy_attachment" "backend_task_s3_attach" {
  role       = aws_iam_role.backend_task_role.name
  policy_arn = aws_iam_policy.lawcloud_s3_cross_account_policy.arn
}

resource "aws_iam_role_policy_attachment" "frontend_task_s3_attach" {
  role       = aws_iam_role.frontend_task_role.name
  policy_arn = aws_iam_policy.lawcloud_s3_cross_account_policy.arn
}


################################################################################
# Optional: Service-specific roles with custom permissions
################################################################################

# Custom service role (if additional services are needed)
resource "aws_iam_role" "custom_service_task_role" {
  count = length(var.custom_services) > 0 ? length(var.custom_services) : 0
  name  = "${var.env}-${var.project}-${var.custom_services[count.index].name}-task-role"

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

  tags = merge(var.tags, {
    Name    = "${var.env}-${var.project}-${var.custom_services[count.index].name}-task-role"
    Type    = "ECS-Task"
    Service = var.custom_services[count.index].name
  })
}

resource "aws_iam_role_policy" "custom_service_task_policy" {
  count = length(var.custom_services) > 0 ? length(var.custom_services) : 0
  name  = "${var.env}-${var.project}-${var.custom_services[count.index].name}-task-policy"
  role  = aws_iam_role.custom_service_task_role[count.index].id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.custom_services[count.index].policy_statements
  })
}

################################################################################
# CloudWatch and Monitoring Roles
################################################################################

# Role for ECS Container Insights and monitoring
resource "aws_iam_role" "ecs_monitoring_role" {
  count = var.enable_container_insights ? 1 : 0
  name  = "${var.env}-${var.project}-ecs-monitoring-role"

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

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-ecs-monitoring-role"
    Type = "ECS-Monitoring"
  })
}

resource "aws_iam_role_policy" "ecs_monitoring_policy" {
  count = var.enable_container_insights ? 1 : 0
  name  = "${var.env}-${var.project}-ecs-monitoring-policy"
  role  = aws_iam_role.ecs_monitoring_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })
}