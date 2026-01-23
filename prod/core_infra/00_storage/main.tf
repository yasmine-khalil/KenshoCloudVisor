data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "ecr_repository" {
  source           = "../../../modules/ecr-scan-on-push"
  env              = var.env
  project          = var.project
  repository_names = ["frontend", "backend"]
}

module "guard_duty" {
  source = "../../../modules/guard-duty"
}

module "cloudtrail" {
  source = "../../../modules/cloudtrail-s3"
  env    = var.env
  project = var.project
}


# module "s3_static_files" {
#   source            = "../../../modules/s3"
#   env               = var.env
#   project           = var.project
#   bucket_suffix     = "static-files"
#   enable_versioning = var.enable_s3_versioning
# }
