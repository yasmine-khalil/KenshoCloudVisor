# ECS Cluster Module

This Terraform module creates an AWS ECS cluster with configurable settings for containerized applications. The module follows single responsibility principle and focuses solely on cluster creation and configuration.

## Features

- ✅ ECS cluster with configurable name and settings
- ✅ Container Insights monitoring (enabled by default)
- ✅ ECS Exec command logging configuration
- ✅ Service Connect namespace support
- ✅ Comprehensive resource tagging
- ✅ Input validation for all variables
- ✅ Support for custom cluster settings

## Architecture

This module creates a clean ECS cluster resource that serves as the foundation for running containerized services. It does not create task definitions, services, or IAM roles - these belong in separate modules following the single responsibility principle.

## Usage

### Basic Usage

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name        = "production-cluster"
  environment = "prod"

  tags = {
    Project = "law-cloud"
    Owner   = "platform-team"
  }
}
```

### Advanced Usage with Custom Settings

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name        = "production-cluster"
  environment = "prod"

  # Custom cluster settings
  cluster_settings = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]

  # ECS Exec configuration
  execute_command_logging        = "OVERRIDE"
  execute_command_log_group_name = "/aws/ecs/exec/production-cluster"

  # Service Connect configuration
  service_connect_defaults = {
    namespace = "production.local"
  }

  tags = {
    Project     = "law-cloud"
    Owner       = "platform-team"
    Environment = "production"
    CostCenter  = "engineering"
  }
}
```

### Minimal Configuration

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name        = "dev-cluster"
  environment = "dev"

  # Disable Container Insights for cost savings in dev
  cluster_settings = [
    {
      name  = "containerInsights"
      value = "disabled"
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Resources Created

- **ECS Cluster**: The main cluster resource for running containerized services
- **Cluster Settings**: Configuration for Container Insights and other cluster features
- **Execute Command Configuration**: Logging setup for ECS Exec sessions
- **Service Connect Defaults**: Default namespace for service mesh communication

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the ECS cluster | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| cluster_settings | List of cluster settings | `list(object)` | Container Insights enabled | no |
| execute_command_logging | Logging configuration for ECS Exec | `string` | `"OVERRIDE"` | no |
| execute_command_log_group_name | CloudWatch log group for ECS Exec logs | `string` | `null` | no |
| service_connect_defaults | Service Connect namespace configuration | `object` | `null` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

### Cluster Settings

The `cluster_settings` variable accepts a list of objects with the following structure:

```hcl
cluster_settings = [
  {
    name  = "containerInsights"  # Currently the only supported setting
    value = "enabled"            # "enabled" or "disabled"
  }
]
```

### Execute Command Logging Options

- **NONE**: No logging for ECS Exec sessions
- **DEFAULT**: Use default AWS logging configuration
- **OVERRIDE**: Use custom CloudWatch log group (requires `execute_command_log_group_name`)

### Service Connect Defaults

```hcl
service_connect_defaults = {
  namespace = "production.local"  # Cloud Map namespace for service discovery
}
```

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the ECS cluster |
| cluster_name | The name of the ECS cluster |
| cluster_arn | The ARN of the ECS cluster |

## Integration Examples

### With ECS Service Module

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  
  name        = "production-cluster"
  environment = "prod"
}

module "ecs_service" {
  source = "./modules/ecs-service"
  
  name       = "main-app"
  cluster_id = module.ecs_cluster.cluster_arn
  # ... other service configuration
}
```

### With CloudWatch Log Group

```hcl
resource "aws_cloudwatch_log_group" "ecs_exec" {
  name              = "/aws/ecs/exec/production-cluster"
  retention_in_days = 30
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  
  name                           = "production-cluster"
  environment                    = "prod"
  execute_command_logging        = "OVERRIDE"
  execute_command_log_group_name = aws_cloudwatch_log_group.ecs_exec.name
}
```

## Container Insights

Container Insights is enabled by default and provides:
- CPU and memory utilization metrics
- Network and storage metrics
- Task and service-level monitoring
- Integration with CloudWatch dashboards

To disable Container Insights (for cost optimization):

```hcl
cluster_settings = [
  {
    name  = "containerInsights"
    value = "disabled"
  }
]
```

## ECS Exec

ECS Exec allows you to run commands in running containers for debugging and troubleshooting. The module configures logging for these sessions.

To use ECS Exec with your services:
1. Enable ECS Exec in your ECS service configuration
2. Ensure your task role has the necessary permissions
3. Use the AWS CLI: `aws ecs execute-command --cluster <cluster-name> --task <task-id> --container <container-name> --interactive --command "/bin/bash"`

## Best Practices

- Use descriptive cluster names that include environment information
- Enable Container Insights for production clusters
- Configure ECS Exec logging for security and compliance
- Use consistent tagging across all resources
- Consider cost implications of Container Insights in development environments

## Security Considerations

- ECS Exec sessions are logged when `execute_command_logging` is configured
- Container Insights data is stored in CloudWatch (consider data retention policies)
- Service Connect provides secure service-to-service communication within the cluster
- All cluster activities are logged to CloudTrail for audit purposes

## Troubleshooting

### Common Issues

1. **Cluster Creation Fails**: Check IAM permissions for ECS cluster creation
2. **Container Insights Not Working**: Verify the cluster setting is enabled and CloudWatch agent permissions
3. **ECS Exec Fails**: Ensure log group exists when using OVERRIDE logging mode
4. **Service Connect Issues**: Verify the namespace exists in Cloud Map

### Debugging

- Check CloudWatch logs for cluster-level events
- Use AWS CLI to describe cluster status: `aws ecs describe-clusters --clusters <cluster-name>`
- Monitor CloudWatch metrics for cluster resource utilization