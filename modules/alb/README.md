# Application Load Balancer (ALB) Module

This module creates an AWS Application Load Balancer with associated security group, target group, and listeners. It automatically creates HTTP (port 80) and HTTPS (port 443) listeners with HTTP to HTTPS redirect when SSL certificate is provided.

## Features

- Application Load Balancer with configurable internal/external access
- Security group with customizable ingress rules
- Target group with health check configuration
- HTTP listener (port 80) - always created
- HTTPS listener (port 443) - created when certificate provided
- Automatic HTTP to HTTPS redirect when certificate provided
- SSL/TLS certificate support
- Deletion protection option
- Comprehensive tagging support

## Usage

```hcl
module "alb" {
  source = "./modules/alb"

  env     = "dev"
  project = "myapp"
  vpc_id  = "vpc-12345678"
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]

  # Optional configurations
  internal = false
  enable_deletion_protection = true
  
  # HTTPS configuration (enables redirect from HTTP)
  certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"
  
  tags = {
    Environment = "dev"
    Team        = "platform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| aws | >= 5.59.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.59.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID where the ALB will be created | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the ALB | `list(string)` | n/a | yes |
| env | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| project | Name of the project - used to create unique resource names | `string` | `"alb"` | no |
| internal | Whether the ALB is internal or internet-facing | `bool` | `false` | no |
| enable_deletion_protection | Enable deletion protection for the ALB | `bool` | `false` | no |
| additional_security_groups | Additional security group IDs to attach to the ALB | `list(string)` | `[]` | no |
| ingress_rules | List of ingress rules for the ALB security group | `list(object)` | HTTP/HTTPS rules | no |
| target_group_port | Port for the target group | `number` | `80` | no |
| target_group_protocol | Protocol for the target group | `string` | `"HTTP"` | no |
| health_check_path | Health check path | `string` | `"/"` | no |
| health_check_healthy_threshold | Number of consecutive health checks successes required | `number` | `2` | no |
| health_check_interval | Interval between health checks | `number` | `30` | no |
| health_check_matcher | Response codes to use when checking for a healthy responses | `string` | `"200"` | no |
| health_check_timeout | Health check timeout | `number` | `5` | no |
| health_check_unhealthy_threshold | Number of consecutive health check failures required | `number` | `2` | no |
| ssl_policy | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| certificate_arn | ARN of the SSL certificate for HTTPS listener (enables HTTPS + HTTP redirect) | `string` | `null` | no |
| tags | A map of tags to use on all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the Application Load Balancer |
| alb_zone_id | Zone ID of the Application Load Balancer |
| target_group_arn | ARN of the target group |
| security_group_id | ID of the ALB security group |
| http_listener_arn | ARN of the HTTP listener |
| https_listener_arn | ARN of the HTTPS listener (null if no certificate) |

## Examples

### Basic HTTP ALB
```hcl
module "alb" {
  source = "./modules/alb"
  
  env        = "dev"
  project    = "webapp"
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
}
```

### HTTPS ALB with HTTP Redirect and Custom Health Check
```hcl
module "alb" {
  source = "./modules/alb"
  
  env           = "prod"
  project       = "api"
  vpc_id        = "vpc-12345678"
  subnet_ids    = ["subnet-12345678", "subnet-87654321"]
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  
  health_check_path    = "/health"
  health_check_matcher = "200,202"
  
  enable_deletion_protection = true
}
```

### HTTP Only ALB
```hcl
module "alb" {
  source = "./modules/alb"
  
  env        = "dev"
  project    = "webapp"
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
  
  # No certificate_arn = HTTP only, no redirect
}
```