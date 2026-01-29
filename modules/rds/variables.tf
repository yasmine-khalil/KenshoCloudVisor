variable "region" {
  type        = string
  description = "The region where the resources should be created"
}
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

variable "vpc_cidr" {
  type        = string
  description = "The ID of the security group used for EC2"
}

variable "vpc_id" {
  type        = string
  description = "The region where the resources should be created"
}

variable "db_private_subnet_a_id" {
  type        = string
  description = "The db subnet A where the RDS db resides"
}

variable "db_private_subnet_b_id" {
  type        = string
  description = "The db subnet A where the RDS db resides"
}

variable "DB_instance_type" {
  type        = string
  description = "Type of the DB instnace. For example db.t3.small"
}

variable "DB_engine_version" {
  type        = string
  description = "Engine version for the database."
}
variable "DB_database_name" {
  type        = string
  description = "Name of your database"
}
variable "DB_master_username" {
  type        = string
  description = "Name of your database"
}
variable "DB_backup_retention_period" {
  type        = number
  description = "Retention period to retain database backups"
}
variable "DB_preferred_backup_window" {
  type        = string
  description = "The time interval when backups can be executed"
}
variable "DB_deletion_protection" {
  type        = bool
  description = "Turns deletion protection on/off"
}
variable "DB_allocated_storage" {
  type        = number
  description = "The allocated storage in gigabytes"
}


