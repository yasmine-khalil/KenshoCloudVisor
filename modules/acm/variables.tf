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

variable "cloudfront_certificate_domain_name" {
  type        = string
  description = "Domain name to create certificate in us-east-1 region (required for CloudFront)"
}

variable "alb_certificate_domain_name" {
  type        = string
  description = "Domain name to create certificate in specific region"
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
