variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Name of the project - used to create unique resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ECS tasks will be launched"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "family" {
  description = "Name of the ECS task family"
  type        = string
}

variable "api_ecr_repository_url" {
  description = "ECR repository URL (without tag)"
  type        = string
}

variable "queue_worker_ecr_repository_url" {
  description = "ECR repository URL (without tag)"
  type        = string
}

variable "scheduler_ecr_repository_url" {
  description = "ECR repository URL (without tag)"
  type        = string
}

variable "subnets" {
  description = "List of private subnet IDs for the ECS service"
  type        = list(string)
}


variable "whitelist_security_groups" {
  description = "List of security group ids to provide access"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets_from_sm" {
  description = "Secrets from AWS Secrets Manager"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
  default     = 1
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for the task"
  type        = string
  default     = "512"
}

variable "enable_ecs_exec" {
  description = "Enable ECS Exec for debugging"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}