################################################################################
# General variables
################################################################################
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
################################################################################
# ECR
################################################################################
variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
}

################################################################################
# S3
################################################################################
variable "enable_s3_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

################################################################################
# RDS
################################################################################
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
