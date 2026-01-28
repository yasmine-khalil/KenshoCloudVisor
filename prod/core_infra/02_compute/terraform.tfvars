
region = "eu-west-1"

project = "kensho"
env     = "prod"

tags = {
  Environment = "prod"
  Project     = "02_compute"
  Owner       = "kensho"
  CostCenter  = "CC-02"
  ManagedBy   = "terraform"
}

####################################################################
# iam-ecs-roles
####################################################################
frontend_s3_resources     = ["*"] # define bucket names that the app needs to reach here. * means every bucket.
backend_s3_resources      = ["*"]
enable_container_insights = true

####################################################################
# ECS SERVICES
####################################################################
# FRONTEND SERVICE
frontend_image          = "207933152498.dkr.ecr.eu-west-1.amazonaws.com/prod-kensho-frontend:latest"
frontend_cpu            = 512
frontend_memory         = 1024
frontend_container_port = 80
frontend_desired_count  = 1

####################################################################
# ECS SERVICES
####################################################################
# BACKEND SERVICE
backend_image          = "207933152498.dkr.ecr.eu-west-1.amazonaws.com/prod-kensho-backend:latest"
backend_cpu            = 1024
backend_memory         = 2048
backend_container_port = 80
backend_desired_count  = 1
