# IAM ECS Roles Module

This Terraform module creates IAM roles and policies for ECS Fargate services following the principle of least privilege. The module provides separate roles for task execution and service-specific task roles with granular permissions.

## Architecture

The module creates two types of roles:
- **Task Execution Role**: Used by ECS to pull container images and write logs
- **Task Roles**: Used by running containers to access AWS services

## Features

- ✅ ECS Task Execution Role with ECR and CloudWatch permissions
- ✅ Service-specific task roles with least privilege access
- ✅ Support for custom services with configurable permissions
- ✅ Container Insights monitoring role (optional)
- ✅ Comprehensive resource tagging
- ✅ Input validation for all variables
- ✅ Support for additional policies and KMS/Secrets Manager access

## Usage

### Basic Usage

```hcl
module "iam_roles" {
  source = "./modules/iam-ecs-roles"

  env     = "prod"
  project = "law-cloud"
  
  # S3 resources for each service
  main_app_s3_resources = [
    "arn:aws:s3:::law-cloud-prod-app-data",
    "arn:aws:s3:::law-cloud-prod-app-data/*"
  ]
  
  violet_service_s3_resources = [
    "arn:aws:s3:::law-cloud-prod-violet-data",
    "arn:aws:s3:::law-cloud-prod-violet-data/*"
  ]
  
  migration_service_s3_resources = [
    "arn:aws:s3:::law-cloud-prod-migration-data",
    "arn:aws:s3:::law-cloud-prod-migration-data/*"
  ]
  
  enable_container_insights = true
  
  tags = {
    Environment = "production"
    Owner       = "platform-team"
    Project     = "law-cloud-migration"
  }
}
```

### Advanced Usage with Custom Services

```hcl
module "iam_roles" {
  source = "./modules/iam-ecs-roles"

  env     = "prod"
  project = "law-cloud"
  
  # Custom services with specific permissions
  custom_services = [
    {
      name = "analytics-service"
      policy_statements = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:ListBucket"
          ]
          Resource = [
            "arn:aws:s3:::analytics-bucket",
            "arn:aws:s3:::analytics-bucket/*"
          ]
        }
      ]
    }
  ]
  
  # Additional policies for task execution role
  additional_task_execution_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
  
  # KMS keys for encryption
  kms_key_arns = [
    "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  ]
  
  # Secrets Manager secrets
  secrets_manager_arns = [
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/law-cloud/db-password-AbCdEf"
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

### Core Roles
- **ECS Task Execution Role**: For pulling images and writing logs
- **Main App Task Role**: For main application service
- **Violet Service Task Role**: For violet service (read-only S3 access)
- **Migration Service Task Role**: For migration service with SSM access

### Optional Roles
- **Custom Service Task Roles**: For additional services with custom permissions
- **ECS Monitoring Role**: For Container Insights (if enabled)

### Policies
- Custom policies for each service with least privilege access
- ECR pull permissions for task execution role
- CloudWatch logs permissions
- Service discovery permissions
- S3 access based on service requirements

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | `string` | n/a | yes |
| project | Project name | `string` | n/a | yes |
| main_app_s3_resources | S3 resources for main app | `list(string)` | `["*"]` | no |
| violet_service_s3_resources | S3 resources for violet service | `list(string)` | `["*"]` | no |
| migration_service_s3_resources | S3 resources for migration service | `list(string)` | `["*"]` | no |
| enable_container_insights | Enable Container Insights role | `bool` | `true` | no |
| custom_services | Custom services with permissions | `list(object)` | `[]` | no |
| additional_task_execution_policies | Additional policies for task execution | `list(string)` | `[]` | no |
| kms_key_arns | KMS key ARNs for access | `list(string)` | `[]` | no |
| secrets_manager_arns | Secrets Manager ARNs | `list(string)` | `[]` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ecs_task_execution_role_arn | ARN of the ECS task execution role |
| main_app_task_role_arn | ARN of the main app task role |
| violet_service_task_role_arn | ARN of the violet service task role |
| migration_service_task_role_arn | ARN of the migration service task role |
| service_task_roles | Map of service names to task role ARNs |
| all_task_role_arns | List of all task role ARNs |

## Security Considerations

### Least Privilege Access
- Each service has its own task role with minimal required permissions
- S3 access is scoped to specific buckets/objects
- CloudWatch permissions are limited to necessary actions
- Service discovery permissions are read-only

### Service-Specific Permissions

#### Main Application
- Full S3 access to designated buckets (read/write/delete)
- CloudWatch metrics and logs
- Service discovery

#### Violet Service
- Read-only S3 access to designated buckets
- CloudWatch metrics and logs
- Service discovery

#### Migration Service
- Full S3 access to migration buckets
- SSM Parameter Store access for configuration
- CloudWatch metrics and logs
- Service discovery

### Best Practices
- All roles follow AWS security best practices
- Resource-based access control where possible
- Comprehensive tagging for governance
- Input validation for all variables

## Integration with ECS

Use the role ARNs in your ECS task definitions:

```hcl
resource "aws_ecs_task_definition" "main_app" {
  family                   = "main-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  
  # Use the task execution role
  execution_role_arn = module.iam_roles.ecs_task_execution_role_arn
  
  # Use the service-specific task role
  task_role_arn = module.iam_roles.main_app_task_role_arn
  
  container_definitions = jsonencode([
    {
      name  = "main-app"
      image = "your-ecr-repo/main-app:latest"
      # ... other container configuration
    }
  ])
}
```

## Compliance

This module supports:
- AWS security best practices for IAM roles
- Principle of least privilege access
- Resource-based access control
- Comprehensive audit logging through CloudTrail
- Proper resource tagging for governance

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**: Verify S3 resource ARNs are correct and include both bucket and object permissions
2. **ECR Pull Failures**: Ensure task execution role has ECR permissions
3. **CloudWatch Logs Issues**: Verify log group permissions in task execution role
4. **Service Discovery Failures**: Check that service discovery permissions are included in task roles

### Debugging

Enable CloudTrail to monitor IAM role usage and identify permission issues. Use AWS IAM Policy Simulator to test permissions before deployment.