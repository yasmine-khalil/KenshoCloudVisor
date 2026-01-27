
variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "dev, prod, stage, test, etc. /it is used to create unique resource names/"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Name of the project /it is used to create unique resource names/"
  type        = string
}


variable "region" {
  description = "Id of AWS region"
  type        = string
}

variable "domain_names" {
  description = "List of domain names for SSL certificates"
  type        = list(string)
  default     = []
}

variable "create_us_east_1_cert" {
  description = "Whether to create certificate in us-east-1 region"
  type        = bool
  default     = false
}

variable "create_regional_cert" {
  type        = bool
  description = "Whether to create certificate in specific region"
  default     = false
}

variable "s3_domain_name" {
  description = "Primary domain name for CloudFront distribution to serve s3 files"
  type        = string
  default     = ""
}
variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name for static files"
}

variable "alb_domain_name" {
  description = "Primary domain name for CloudFront distribution to serve application traffic"
  type        = string
  default     = ""
}

variable "create_waf" {
  type        = bool
  description = "Whether to create the WAF Web ACL"
  default     = true
}