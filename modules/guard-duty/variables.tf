variable "enable_guard_duty" {
  type        = bool
  description = "Enable GuardDuty"
  default     = true
}

variable "extra_feature_eks_protection" {
  type        = bool
  description = "Enable EKS audit logs"
  default     = false
}

variable "extra_feature_eks_runtime_monitoring" {
  type        = bool
  description = "Enable full EKS runtime monitoring"
  default     = false
}

variable "extra_feature_runtime_monitoring" {
  type        = bool
  description = "Enable full runtime monitoring (this includes full eks runtime monitoring)"
  default     = false
}

variable "extra_feature_lambda_protection" {
  type        = bool
  description = "Enable lambda network logs"
  default     = false
}

variable "extra_feature_rds_protection" {
  type        = bool
  description = "Enable RDS login events"
  default     = false
}

variable "extra_feature_s3_protection" {
  type        = bool
  description = "Enable S3 data events"
  default     = true
}
