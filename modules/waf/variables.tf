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

variable "scope" {
  type        = string
  description = "Scope of the WAF - CLOUDFRONT or REGIONAL (for ALB)"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "scope must be either CLOUDFRONT or REGIONAL"
  }
}

variable "create_waf" {
  type        = bool
  description = "Whether to create the WAF Web ACL"
  default     = true
}

variable "resource_arn" {
  type        = string
  description = "ARN of the CloudFront distribution or ALB to associate with WAF (optional)"
  default     = null
}
