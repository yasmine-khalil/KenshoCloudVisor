
variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "dev, prod, stage, test, etc. /it is used to create unique resource names/"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Name of the project /it is used to create unique resource names/"
  type        = string
}


variable "region" {
  description = "Id of AWS region"
  type        = string
}

# variable "cluster_name" {
#   description = "Name of the ECS cluster"
#   type        = string
#   default     = ""
# }

# variable "service_name" {
#   description = "Name of the ECS service"
#   type        = string
#   default     = ""
# }

# variable "family" {
#   description = "Name of the ECS task family"
#   type        = string
#   default     = ""
# }

# variable "environment_variables" {
#   description = "Environment variables for the container"
#   type = list(object({
#     name  = string
#     value = string
#   }))
#   default = []
# }

# variable "secrets_from_sm" {
#   description = "Secrets from AWS Secrets Manager"
#   type = list(object({
#     name      = string
#     valueFrom = string
#   }))
#   default = []
# }

# variable "desired_count" {
#   description = "Number of desired tasks"
#   type        = number
#   default     = 1
# }

# variable "frontend_port" {
#   description = "Port on which the frontend container listens"
#   type        = number
#   default     = 80
# }

# variable "backend_port" {
#   description = "Port on which the backend container listens"
#   type        = number
#   default     = 3000
# }

# variable "cpu" {
#   description = "CPU units for the task"
#   type        = string
#   default     = "256"
# }

# variable "memory" {
#   description = "Memory for the task"
#   type        = string
#   default     = "512"
# }


####################################################################
# iam-ecs-roles
####################################################################
variable "enable_container_insights" {
  description = "Enable Container Insights for detailed ECS monitoring"
  type        = bool
  default     = true
}

variable "ecs_execute_command_logging" {
  description = "Logging configuration for ECS Exec (NONE, DEFAULT, OVERRIDE)"
  type        = string
  default     = "OVERRIDE"

  validation {
    condition     = contains(["NONE", "DEFAULT", "OVERRIDE"], var.ecs_execute_command_logging)
    error_message = "ecs_execute_command_logging must be NONE, DEFAULT, or OVERRIDE."
  }
}

variable "frontend_s3_resources" {
  description = "List of S3 resource ARNs that the main application needs access to"
  type        = list(string)
  default     = ["*"]

  validation {
    condition = alltrue([
      for arn in var.frontend_s3_resources : can(regex("^arn:aws:s3:::", arn)) || arn == "*"
    ])
    error_message = "All S3 resources must be valid S3 ARNs or '*'."
  }
}

variable "backend_s3_resources" {
  description = "List of S3 resource ARNs that the violet service needs access to (read-only)"
  type        = list(string)
  default     = ["*"]

  validation {
    condition = alltrue([
      for arn in var.backend_s3_resources : can(regex("^arn:aws:s3:::", arn)) || arn == "*"
    ])
    error_message = "All S3 resources must be valid S3 ARNs or '*'."
  }
}


####################################################################
# ECS Configuration
####################################################################

# FRONTEND ########################################################
variable "frontend_image" {
  description = "Docker image URI"
  type        = string
}

variable "frontend_container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "frontend_cpu" {
  description = "Fargate CPU units (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 512
}

variable "frontend_memory" {
  description = "Fargate memory in MB (must be compatible with CPU)"
  type        = number
  default     = 1024
}

variable "frontend_desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 2
}

variable "frontend_health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

variable "frontend_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

# BACKEND ########################################################
variable "backend_image" {
  description = "Docker image URI"
  type        = string
}

variable "backend_container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "backend_cpu" {
  description = "Fargate CPU units (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 512
}

variable "backend_memory" {
  description = "Fargate memory in MB (must be compatible with CPU)"
  type        = number
  default     = 1024
}

variable "backend_desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 2
}

variable "backend_health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

variable "backend_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}