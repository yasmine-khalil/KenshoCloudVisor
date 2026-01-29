variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cloudtrail_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
