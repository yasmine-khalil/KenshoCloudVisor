
locals {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.project}"]
  }
}

data "aws_subnets" "app_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.project}-app-subnet-*"]
  }
}

data "aws_security_group" "alb_sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.env}-${var.project}-alb-sg"]
  }
}

data "aws_lb_target_group" "alb_tg" {
  name = "${var.env}-${var.project}-tg"
}

data "aws_ecr_repository" "ecr_repo_api" {
  name = "${var.env}-${var.project}-api"
}
data "aws_ecr_repository" "ecr_repo_queue_worker" {
  name = "${var.env}-${var.project}-queue-worker"
}

data "aws_ecr_repository" "ecr_repo_scheduler" {
  name = "${var.env}-${var.project}-scheduler"
}

data "aws_secretsmanager_secret" "rds_db_credentials" {
  name = "${var.env}/${var.project}/rds/db/credentials"
}

data "aws_secretsmanager_secret" "redis_credentials" {
  name = "${var.env}/${var.project}/redis/credentials"
}

data "aws_secretsmanager_secret" "cloudfront_s3_private_key" {
  name = "${var.env}/${var.project}/cloudfront/s3/private_key"
}

resource "aws_secretsmanager_secret" "environment_variables_secret" {
  name        = "${var.env}/${var.project}/environment/variables"
  description = "All application environment variables"

  tags = merge(var.tags, {
    Name        = "${var.env}/${var.project}/environment/variables"
    Environment = var.env
    Project     = var.project
  })
}

module "ecs_cluster" {
  source = "../../../modules/ecs-cluster"

  env     = var.env
  project = var.project

  cluster_name = "${var.env}-${var.project}-cluster"
  service_name = "${var.env}-${var.project}-service"
  family       = "${var.env}-${var.project}-ecs-task"

  # ECR configuration
  api_ecr_repository_url          = data.aws_ecr_repository.ecr_repo_api.repository_url
  queue_worker_ecr_repository_url = data.aws_ecr_repository.ecr_repo_queue_worker.repository_url
  scheduler_ecr_repository_url    = data.aws_ecr_repository.ecr_repo_scheduler.repository_url

  # Network configuration (private subnets)
  vpc_id                    = data.aws_vpc.selected.id
  subnets                   = data.aws_subnets.app_subnets.ids
  whitelist_security_groups = [data.aws_security_group.alb_sg.id]

  # ALB integration
  target_group_arn = data.aws_lb_target_group.alb_tg.arn
  container_port   = var.container_port

  # Environment variables
  environment_variables = [
    {
      name  = "APP_PORT"
      value = var.container_port
    }
  ]

  # Secrets from Secrets Manager
  secrets_from_sm = [
    {
      name      = "DB_HOST"
      valueFrom = "${data.aws_secretsmanager_secret.rds_db_credentials.arn}:host::"
    },
    {
      name      = "DB_PORT"
      valueFrom = "${data.aws_secretsmanager_secret.rds_db_credentials.arn}:port::"
    },
    {
      name      = "DB_USER"
      valueFrom = "${data.aws_secretsmanager_secret.rds_db_credentials.arn}:username::"
    },
    {
      name      = "DB_PASS"
      valueFrom = "${data.aws_secretsmanager_secret.rds_db_credentials.arn}:password::"
    },
    {
      name      = "DB_NAME"
      valueFrom = "${data.aws_secretsmanager_secret.rds_db_credentials.arn}:dbname::"
    },
    {
      name      = "REDIS_HOST"
      valueFrom = "${data.aws_secretsmanager_secret.redis_credentials.arn}:host::"
    },
    {
      name      = "REDIS_PORT"
      valueFrom = "${data.aws_secretsmanager_secret.redis_credentials.arn}:port::"
    },
    {
      name      = "REDIS_USER"
      valueFrom = "${data.aws_secretsmanager_secret.redis_credentials.arn}:username::"
    },
    {
      name      = "REDIS_PASSWORD"
      valueFrom = "${data.aws_secretsmanager_secret.redis_credentials.arn}:password::"
    },
    {
      name      = "CLOUDFRONT_PRIVATE_KEY"
      valueFrom = "${data.aws_secretsmanager_secret.cloudfront_s3_private_key.arn}"
    },
    {
      name      = "ACTIVITY_VISIBILITY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:ACTIVITY_VISIBILITY::"
    },
    {
      name      = "APP_DEBUG"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:APP_DEBUG::"
    },
    {
      name      = "APP_KEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:APP_KEY::"
    },
    {
      name      = "APP_NAME"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:APP_NAME::"
    },
    {
      name      = "APP_TIMEZONE"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:APP_TIMEZONE::"
    },
    {
      name      = "APP_URL"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:APP_URL::"
    },
    {
      name      = "AWS_ACCESS_KEY_ID"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:AWS_ACCESS_KEY_ID::"
    },
    {
      name      = "AWS_BUCKET"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:AWS_BUCKET::"
    },
    {
      name      = "AWS_DEFAULT_REGION"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:AWS_DEFAULT_REGION::"
    },
    {
      name      = "AWS_ENDPOINT"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:AWS_ENDPOINT::"
    },
    {
      name      = "AWS_SECRET_ACCESS_KEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:AWS_SECRET_ACCESS_KEY::"
    },
    {
      name      = "BROADCAST_DRIVER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:BROADCAST_DRIVER::"
    },
    {
      name      = "CACHE_DRIVER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:CACHE_DRIVER::"
    },
    {
      name      = "CHANNEL_PREFIX"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:CHANNEL_PREFIX::"
    },
    {
      name      = "FILESYSTEM_DISK"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:FILESYSTEM_DISK::"
    },
    {
      name      = "FILESYSTEM_DRIVER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:FILESYSTEM_DRIVER::"
    },
    {
      name      = "GEMINI_API_KEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:GEMINI_API_KEY::"
    },
    {
      name      = "GOOGLE_APPLICATION_CREDENTIALS"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:GOOGLE_APPLICATION_CREDENTIALS::"
    },
    {
      name      = "INVOICE_DESTINATION_ACCOUNT"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:INVOICE_DESTINATION_ACCOUNT::"
    },
    {
      name      = "JWT_LIFETIME"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:JWT_LIFETIME::"
    },
    {
      name      = "JWT_SECRET"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:JWT_SECRET::"
    },
    {
      name      = "LOGO_URL"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:LOGO_URL::"
    },
    {
      name      = "LOG_CHANNEL"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:LOG_CHANNEL::"
    },
    {
      name      = "MAILJET_APIKEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAILJET_APIKEY::"
    },
    {
      name      = "MAILJET_APISECRET"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAILJET_APISECRET::"
    },
    {
      name      = "MAIL_MAILER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAIL_MAILER::"
    },
    {
      name      = "MAIL_FROM_ADDRESS"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAIL_FROM_ADDRESS::"
    },
    {
      name      = "MAIL_FROM_NAME"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAIL_FROM_NAME::"
    },
    {
      name      = "MAIL_REPLY_ADDRESS"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:MAIL_REPLY_ADDRESS::"
    },
    {
      name      = "PAYMENT_NOTIFICATION_EMAIL"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PAYMENT_NOTIFICATION_EMAIL::"
    },
    {
      name      = "PLATFORM_STRIPE_KEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PLATFORM_STRIPE_KEY::"
    },
    {
      name      = "PLATFORM_STRIPE_SECRET"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PLATFORM_STRIPE_SECRET::"
    },
    {
      name      = "POSTMARK_TOKEN"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:POSTMARK_TOKEN::"
    },
    {
      name      = "PUSHER_APP_CLUSTER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PUSHER_APP_CLUSTER::"
    },
    {
      name      = "PUSHER_APP_ID"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PUSHER_APP_ID::"
    },
    {
      name      = "PUSHER_APP_KEY"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PUSHER_APP_KEY::"
    },
    {
      name      = "PUSHER_APP_SECRET"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:PUSHER_APP_SECRET::"
    },
    {
      name      = "QUEUE_CONNECTION"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:QUEUE_CONNECTION::"
    },
    {
      name      = "SESSION_DRIVER"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:SESSION_DRIVER::"
    },
    {
      name      = "SESSION_LIFETIME"
      valueFrom = "${aws_secretsmanager_secret.environment_variables_secret.arn}:SESSION_LIFETIME::"
    }

  ]

  cpu             = "2048" # 2 vCPU
  memory          = "4096" # 4 GiB
  enable_ecs_exec = true
}

module "github-oidc" {
  source = "../../../modules/github-oidc-provider"

  role_name            = "${var.env}-${var.project}-github-oidc-provider-aws"
  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = ["kensho-hq/kensho-api:ref:refs/heads/deploy/${var.env == "prod" ? "prod" : "staging"}"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser", "arn:aws:iam::aws:policy/AmazonECS_FullAccess"]
}