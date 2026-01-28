variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ARN"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the app service task role"
  type        = string
}

variable "image" {
  description = "Docker image URI"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "Fargate CPU units (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Fargate memory in MB (must be compatible with CPU)"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 2
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "load_balancer_target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
