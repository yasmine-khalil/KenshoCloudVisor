variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
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

variable "s3_custom_domain_name" {
  description = "Primary domain name for CloudFront distribution to serve s3 files"
  type        = string
  default     = ""
}

variable "alb_custom_domain_name" {
  description = "Primary domain name for CloudFront distribution to serve application traffic"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN in us-east-1 region for CloudFront"
}

variable "alb_domain_name" {
  type        = string
  description = "Internal ALB domain name for dynamic content origin"
}

variable "alb_arn" {
  type        = string
  description = "ARN of the internal ALB for VPC origin"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the internal ALB is located"
}

variable "s3_bucket_domain_name" {
  type        = string
  description = "S3 bucket regional domain name for static content origin"
}

variable "s3_bucket_id" {
  type        = string
  description = "S3 bucket ID for OAC policy"
}

variable "cloudfront_security_header_value" {
  type        = string
  description = "Security header value to send to ALB"
}

variable "upload_path_pattern" {
  type        = string
  description = "Path pattern for uploaded images (e.g., /upload/*)"
  default     = "/upload/*"
}

variable "web_acl_id" {
  type        = string
  description = "WAF Web ACL ID to associate with CloudFront distributions"
  default     = null
}