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

variable "region" {
  type        = string
  description = "AWS region for regional certificate"
}

variable "domain_names" {
  type        = list(string)
  description = "List of FQDNs for SSL certificate"

  validation {
    condition     = length(var.domain_names) > 0
    error_message = "At least one domain name must be provided"
  }
}

variable "create_us_east_1_cert" {
  type        = bool
  description = "Whether to create certificate in us-east-1 region (required for CloudFront)"
  default     = false
}

variable "create_regional_cert" {
  type        = bool
  description = "Whether to create certificate in specific region"
  default     = false
}