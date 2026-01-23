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

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC - must be a /16 network (e.g., 10.20.0.0/16)"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block"
  }

  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.0\\.0/16$", var.vpc_cidr))
    error_message = "vpc_cidr must be a /16 network ending in 0.0/16 (e.g., 10.20.0.0/16)"
  }
}
