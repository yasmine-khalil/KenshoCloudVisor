####################################################################
# General variables
####################################################################
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
####################################################################
# acm
####################################################################
variable "cloudfront_certificate_domain_name" {
  type        = string
  description = "Domain name to create certificate in us-east-1 region (required for CloudFront)"
}

variable "alb_certificate_domain_name" {
  type        = string
  description = "Domain name to create certificate in specific region"
}

####################################################################
# waf
####################################################################
variable "create_waf" {
  type        = bool
  description = "Whether to create the WAF Web ACL"
  default     = true
}

####################################################################
# 
####################################################################