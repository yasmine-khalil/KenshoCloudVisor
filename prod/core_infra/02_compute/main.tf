data "terraform_remote_state" "networking" {
  backend = "s3" 

  config = {
    # Replace these with the actual values used in 01_networking's backend config
    bucket         = "terraform-state-207933152498-eu-west-1"
    key            = "prod/core_infra/01_networking.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}



module "ecs_cluster" {
  source = "../../../modules/ecs-cluster"

  name        = "${var.project}-${var.env}"
  environment = var.env

  tags = var.tags
}

module "ecs_iam_roles" {
  source = "../../../modules/ecs-iam-roles"

  env     = var.env
  project = var.project
  frontend_s3_resources  = var.frontend_s3_resources
  backend_s3_resources   = var.backend_s3_resources
  enable_container_insights = var.enable_container_insights

  tags = var.tags
}


module "backend-service" {
  source = "../../../modules/ecs-services/backend-service"

  project_name                   = var.project
  environment                    = var.env
  aws_region                     = var.region
  vpc_id                         = data.terraform_remote_state.networking.outputs.vpc_id
  vpc_cidr                       = data.terraform_remote_state.networking.outputs.vpc_cidr
  cluster_id                     = module.ecs_cluster.cluster_arn
  private_subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids
  ecs_task_execution_role_arn    = module.ecs_iam_roles.ecs_task_execution_role_arn
  task_role_arn                  = module.ecs_iam_roles.backend_task_role_arn
  image                          = var.backend_image
  container_port                 = var.backend_container_port
  cpu                            = var.backend_cpu
  memory                         = var.backend_memory
  desired_count                  = var.backend_desired_count
  log_retention_days             = var.backend_log_retention_days
  load_balancer_target_group_arn = data.terraform_remote_state.networking.outputs.backend_target_group_arn

  tags                           = var.tags
}

module "frontend-service" {
  source = "../../../modules/ecs-services/frontend-service"

  project_name                   = var.project
  environment                    = var.env
  aws_region                     = var.region
  vpc_id                         = data.terraform_remote_state.networking.outputs.vpc_id
  vpc_cidr                       = data.terraform_remote_state.networking.outputs.vpc_cidr
  cluster_id                     = module.ecs_cluster.cluster_arn
  private_subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids
  ecs_task_execution_role_arn    = module.ecs_iam_roles.ecs_task_execution_role_arn
  task_role_arn                  = module.ecs_iam_roles.frontend_task_role_arn
  image                          = var.frontend_image
  container_port                 = var.frontend_container_port
  cpu                            = var.frontend_cpu
  memory                         = var.frontend_memory
  desired_count                  = var.frontend_desired_count
  log_retention_days             = var.frontend_log_retention_days
  load_balancer_target_group_arn = data.terraform_remote_state.networking.outputs.frontend_target_group_arn

  tags                           = var.tags
}