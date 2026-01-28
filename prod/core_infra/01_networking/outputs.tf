output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [module.vpc.public_subnet_a_id, module.vpc.public_subnet_b_id]
}

output "backend_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.backend_target_group_arn
}

output "frontend_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.frontend_target_group_arn
}