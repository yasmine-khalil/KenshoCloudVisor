
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

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "enable_s3_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}
