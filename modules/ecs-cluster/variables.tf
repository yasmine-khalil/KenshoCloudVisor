####################################################################
# Variables - Cluster-related configuration
####################################################################

variable "name" {
  description = "Name of the ECS cluster"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "name must be between 1 and 255 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "name must contain only alphanumeric characters, hyphens, and underscores"
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string

  validation {
    condition     = length(var.environment) > 0 && length(var.environment) <= 50
    error_message = "environment must be between 1 and 50 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.environment))
    error_message = "environment must contain only alphanumeric characters and hyphens"
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
