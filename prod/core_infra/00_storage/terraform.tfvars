################################################################################
# General variables
################################################################################
region  = "eu-west-1"
project = "kensho"
env     = "prod"
################################################################################
# ECR
################################################################################
ecr_repository_name = "api"
################################################################################
# S3
################################################################################
enable_s3_versioning = false
################################################################################
# RDS
################################################################################
DB_master_username         = "masteruser"
DB_database_name           = "kensho_production"       #TODO ask customer if it is okay
DB_engine_version          = "17.7"         #TODO ask customer if it is okay
DB_instance_type           = "db.t3.medium" #TODO change this based on customer input! Now it is set to be the smallest
DB_preferred_backup_window = "23:00-05:00"
DB_backup_retention_period = 30
DB_deletion_protection     = true
DB_allocated_storage       = 200