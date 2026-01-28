variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod, staging) - used to create unique resource names"

  validation {
    condition     = length(var.env) > 0 && length(var.env) <= 50
    error_message = "env must be between 1 and 50 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.env))
    error_message = "env must contain only alphanumeric characters and hyphens"
  }
}

variable "project" {
  type        = string
  description = "Project name - used to create unique resource names"

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 50
    error_message = "project must be between 1 and 50 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project))
    error_message = "project must contain only alphanumeric characters and hyphens"
  }
}

variable "frontend_s3_resources" {
  type        = list(string)
  description = "List of S3 resource ARNs that the main application needs access to"
  default     = ["*"]

  validation {
    condition = alltrue([
      for arn in var.frontend_s3_resources : can(regex("^arn:aws:s3:::", arn)) || arn == "*"
    ])
    error_message = "All S3 resources must be valid S3 ARNs or '*'"
  }
}

variable "backend_s3_resources" {
  type        = list(string)
  description = "List of S3 resource ARNs that the violet service needs access to (read-only)"
  default     = ["*"]

  validation {
    condition = alltrue([
      for arn in var.backend_s3_resources : can(regex("^arn:aws:s3:::", arn)) || arn == "*"
    ])
    error_message = "All S3 resources must be valid S3 ARNs or '*'"
  }
}

variable "enable_container_insights" {
  type        = bool
  description = "Enable Container Insights monitoring role"
  default     = true
}

variable "custom_services" {
  type = list(object({
    name = string
    policy_statements = list(object({
      Effect   = string
      Action   = list(string)
      Resource = list(string)
    }))
  }))
  description = "List of custom services with their specific IAM policy statements"
  default     = []

  validation {
    condition = alltrue([
      for service in var.custom_services : can(regex("^[a-zA-Z0-9-]+$", service.name))
    ])
    error_message = "Service names must contain only alphanumeric characters and hyphens"
  }

  validation {
    condition = alltrue([
      for service in var.custom_services : alltrue([
        for statement in service.policy_statements : contains(["Allow", "Deny"], statement.Effect)
      ])
    ])
    error_message = "Policy statement Effect must be either 'Allow' or 'Deny'"
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all IAM resources"
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s\\-_.:/@]+$", k)) && can(regex("^[a-zA-Z0-9\\s\\-_.:/@]*$", v))
    ])
    error_message = "Tags must contain only alphanumeric characters, spaces, and the following special characters: - _ . : / @"
  }
}

variable "additional_task_execution_policies" {
  type        = list(string)
  description = "List of additional IAM policy ARNs to attach to the ECS task execution role"
  default     = []

  validation {
    condition = alltrue([
      for arn in var.additional_task_execution_policies : can(regex("^arn:aws:iam::", arn))
    ])
    error_message = "All policy ARNs must be valid IAM policy ARNs"
  }
}
