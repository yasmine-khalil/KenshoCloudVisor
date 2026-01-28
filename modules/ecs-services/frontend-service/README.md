# App Service ECS Module

This module creates an ECS Fargate service for the main application with load balancer integration, CloudWatch logging, and autoscaling.

## Features

- ✅ Fargate task definition with configurable CPU/memory
- ✅ CloudWatch logging with awslogs driver
- ✅ Load balancer (ALB) integration
- ✅ ECS Exec enabled for debugging
- ✅ CPU and memory-based autoscaling
- ✅ Deployment circuit breaker with automatic rollback
- ✅ Environment variables support
- ✅ Health check configuration

## Usage

```hcl
module "ecs_app_service" {
  source = "./modules/ecs-app-service"

  project_name                 = "law-cloud"
  environment                  = "prod"
  aws_region                   = "us-east-1"
  cluster_id                   = module.ecs_cluster.cluster_arn
  ecs_task_execution_role_arn  = module.iam_ecs_roles.ecs_task_execution_role_arn
  task_role_arn                = module.iam_ecs_roles.main_app_task_role_arn
  image                        = "123456789012.dkr.ecr.us-east-1.amazonaws.com/app-service:latest"
  container_port               = 8080
  cpu                          = 512
  memory                        = 1024
  desired_count                = 2
  private_subnet_ids           = module.vpc.private_subnet_ids
  ecs_security_group_id        = aws_security_group.ecs_service.id
  load_balancer_target_group_arn = module.alb.target_group_arn

  environment_variables = [
    {
      name  = "LOG_LEVEL"
      value = "INFO"
    },
    {
      name  = "ENVIRONMENT"
      value = "prod"
    }
  ]

  autoscaling_min_capacity  = 2
  autoscaling_max_capacity  = 10
  autoscaling_cpu_target    = 70
  autoscaling_memory_target = 80

  tags = {
    Project = "law-cloud"
    Owner   = "platform-team"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_name | Project name | `string` | n/a |
| environment | Environment name | `string` | n/a |
| aws_region | AWS region | `string` | n/a |
| cluster_id | ECS cluster ARN | `string` | n/a |
| ecs_task_execution_role_arn | Task execution role ARN | `string` | n/a |
| task_role_arn | Task role ARN | `string` | n/a |
| image | Docker image URI | `string` | n/a |
| container_port | Container port | `number` | 8080 |
| cpu | Fargate CPU units | `number` | 512 |
| memory | Fargate memory in MB | `number` | 1024 |
| desired_count | Number of tasks | `number` | 2 |
| private_subnet_ids | Private subnet IDs | `list(string)` | n/a |
| ecs_security_group_id | Security group ID | `string` | n/a |
| load_balancer_target_group_arn | ALB target group ARN | `string` | n/a |
| health_check_grace_period_seconds | Grace period | `number` | 60 |
| environment_variables | Environment variables | `list(object)` | [] |
| autoscaling_min_capacity | Min tasks | `number` | 2 |
| autoscaling_max_capacity | Max tasks | `number` | 10 |
| autoscaling_cpu_target | CPU utilization target | `number` | 70 |
| autoscaling_memory_target | Memory utilization target | `number` | 80 |
| autoscaling_scale_in_cooldown | Scale-in cooldown | `number` | 300 |
| autoscaling_scale_out_cooldown | Scale-out cooldown | `number` | 300 |
| log_retention_days | Log retention days | `number` | 7 |
| tags | Tags to apply | `map(string)` | {} |

## Outputs

| Name | Description |
|------|-------------|
| task_definition_arn | Task definition ARN |
| service_arn | Service ARN |
| service_name | Service name |
| log_group_name | CloudWatch log group name |
| autoscaling_target_arn | Autoscaling target ARN |
