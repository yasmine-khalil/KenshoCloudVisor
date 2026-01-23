variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment name (e.g., dev, prod, staging) - used to create unique resource names"
  type        = string

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
  description = "Project name - used to create unique resource names"
  type        = string

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 50
    error_message = "project must be between 1 and 50 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project))
    error_message = "project must contain only alphanumeric characters and hyphens"
  }
}

variable "enable_logging" {
  description = "Enable/disable logging for the CloudTrail trail"
  type        = bool
  default     = true
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail logs (use empty string for root)"
  type        = string
  default     = ""
}

variable "use_kms_encryption" {
  description = "Enable KMS encryption for CloudTrail logs (recommended for compliance)"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Create a new KMS key for CloudTrail encryption (only used if use_kms_encryption is true)"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Existing KMS key ARN for CloudTrail encryption (only used when create_kms_key is false)"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_id))
    error_message = "kms_key_id must be a valid KMS key ARN or null"
  }
}

variable "kms_deletion_window" {
  description = "Number of days to retain the KMS key before permanent deletion (7-30 days)"
  type        = number
  default     = 10

  validation {
    condition     = var.kms_deletion_window >= 7 && var.kms_deletion_window <= 30
    error_message = "kms_deletion_window must be between 7 and 30 days"
  }
}

variable "enable_access_logging" {
  description = "Enable S3 access logging for the CloudTrail bucket"
  type        = bool
  default     = false
}
