# ECS Cluster Module

This module creates an ECS cluster with Fargate tasks that:
- Creates ECS cluster, service, and task definitions
- Uses latest images from multiple ECR repositories (API, Queue Worker, Scheduler)
- Deploys tasks in private subnets with Fargate launch type
- Includes IAM roles for task execution and task permissions
- Integrates with ALB target group for load balancing
- Supports CloudWatch logging
- Configurable ECS Exec for debugging
- Manages secrets from AWS Secrets Manager

## Requirements

- ECR repositories for API, Queue Worker, and Scheduler
- Private subnets for task placement
- ALB target group for load balancing
- Secrets Manager secrets for sensitive data
- VPC with proper security groups

## Usage

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  env     = "prod"
  project = "kensho"
  vpc_id  = "vpc-12345"
  
  cluster_name = "prod-kensho-cluster"
  service_name = "prod-kensho-service"
  family       = "prod-kensho-task"

  api_ecr_repository_url         = "123456789012.dkr.ecr.us-east-1.amazonaws.com/prod-kensho-api"
  queue_worker_ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/prod-kensho-queue-worker"
  scheduler_ecr_repository_url   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/prod-kensho-scheduler"
  
  subnets                   = ["subnet-12345", "subnet-67890"]
  whitelist_security_groups = ["sg-12345"]
  target_group_arn         = "arn:aws:elasticloadbalancing:..."
  
  environment_variables = [
    {
      name  = "APP_ENV"
      value = "production"
    }
  ]
  
  secrets_from_sm = [
    {
      name      = "DB_PASSWORD"
      valueFrom = "arn:aws:secretsmanager:..."
    }
  ]
  
  enable_ecs_exec = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| vpc_id | VPC ID where ECS tasks will be launched | string | - | Y |
| cluster_name | Name of the ECS cluster | string | - | Y |
| service_name | Name of the ECS service | string | - | Y |
| family | Name of the ECS task family | string | - | Y |
| api_ecr_repository_url | ECR repository URL for API (without tag) | string | - | Y |
| queue_worker_ecr_repository_url | ECR repository URL for Queue Worker (without tag) | string | - | Y |
| scheduler_ecr_repository_url | ECR repository URL for Scheduler (without tag) | string | - | Y |
| subnets | List of private subnet IDs for ECS service | list(string) | - | Y |
| whitelist_security_groups | List of security group IDs to provide access | list(string) | - | Y |
| target_group_arn | ARN of the ALB target group | string | - | Y |
| environment_variables | Environment variables for container | list(object) | [] | N |
| secrets_from_sm | Secrets from AWS Secrets Manager | list(object) | [] | N |
| desired_count | Number of desired tasks | number | 1 | N |
| container_port | Port on which container listens | number | 8000 | N |
| cpu | CPU units for the task | string | "256" | N |
| memory | Memory for the task | string | "512" | N |
| enable_ecs_exec | Enable ECS Exec for debugging | bool | false | N |
| tags | A map of tags to use on all resources | map(string) | {} | N |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | Name of the ECS cluster |
| cluster_arn | ARN of the ECS cluster |
| ecs_service_name | Name of the ECS service |
| ecs_service_arn | ARN of the ECS service |
| task_definition_arn | ARN of the ECS task definition |
| security_group_id | ID of the ECS security group |