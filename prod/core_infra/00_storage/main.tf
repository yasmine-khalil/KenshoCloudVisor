data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    # These values must match the actual values used in 01_networking's backend config
    bucket       = "terraform-state-207933152498-eu-west-1"
    key          = "prod/core_infra/01_networking.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
  }
}

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
  source = "../../../modules/cloudtrail"

  environment            = var.env
  project_name           = var.project
  region                 = var.region
  cloudtrail_bucket_name = "${var.env}-${var.project}-cloudtrail-${data.aws_caller_identity.current.account_id}"

}

module "s3_documents" {
  source            = "../../../modules/s3"
  env               = var.env
  project           = var.project
  bucket_suffix     = "documents"
  enable_versioning = var.enable_s3_versioning
}

module "rds" {
  source                     = "../../../modules/rds"
  env                        = var.env
  project                    = var.project
  DB_master_username         = var.DB_master_username
  DB_database_name           = var.DB_database_name
  DB_engine_version          = var.DB_engine_version
  DB_instance_type           = var.DB_instance_type
  DB_backup_retention_period = var.DB_backup_retention_period
  DB_preferred_backup_window = var.DB_preferred_backup_window
  DB_deletion_protection     = var.DB_deletion_protection
  DB_allocated_storage       = var.DB_allocated_storage
  region                     = var.region
  vpc_id                     = data.terraform_remote_state.networking.outputs.vpc_id
  vpc_cidr                   = data.terraform_remote_state.networking.outputs.vpc_cidr
  db_private_subnet_a_id     = data.terraform_remote_state.networking.outputs.private_subnet_ids[0]
  db_private_subnet_b_id     = data.terraform_remote_state.networking.outputs.private_subnet_ids[1]
  tags                       = var.tags
}

