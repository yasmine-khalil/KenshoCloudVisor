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

variable "vpc_id" {
  type        = string
  description = "VPC ID where bastion host will be deployed"
}

variable "ami_id" {
  type        = string
  description = "ami id of linux os"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for bastion host placement"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for bastion host"
  default     = "t3.micro"
}

variable "create_elastic_ip" {
  type        = bool
  description = "Whether to create and attach an Elastic IP to the bastion host"
  default     = true
}