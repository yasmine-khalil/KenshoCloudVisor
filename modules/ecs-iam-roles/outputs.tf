################################################################################
# ECS Task Execution Role Outputs
################################################################################
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.name
}

################################################################################
# Service-Specific Task Role Outputs
################################################################################
output "frontend_task_role_arn" {
  description = "ARN of the frontend task role"
  value       = aws_iam_role.frontend_task_role.arn
}

output "frontend_task_role_name" {
  description = "Name of the frontend task role"
  value       = aws_iam_role.frontend_task_role.name
}

output "backend_task_role_arn" {
  description = "ARN of the backend task role"
  value       = aws_iam_role.backend_task_role.arn
}

output "backend_task_role_name" {
  description = "Name of the backend task role"
  value       = aws_iam_role.backend_task_role.name
}


################################################################################
# Custom Service Role Outputs
################################################################################
output "custom_service_task_role_arns" {
  description = "Map of custom service names to their task role ARNs"
  value = length(var.custom_services) > 0 ? {
    for i, service in var.custom_services : service.name => aws_iam_role.custom_service_task_role[i].arn
  } : {}
}

output "custom_service_task_role_names" {
  description = "Map of custom service names to their task role names"
  value = length(var.custom_services) > 0 ? {
    for i, service in var.custom_services : service.name => aws_iam_role.custom_service_task_role[i].name
  } : {}
}

################################################################################
# Monitoring Role Outputs
################################################################################
output "ecs_monitoring_role_arn" {
  description = "ARN of the ECS monitoring role (if enabled)"
  value       = var.enable_container_insights ? aws_iam_role.ecs_monitoring_role[0].arn : null
}

output "ecs_monitoring_role_name" {
  description = "Name of the ECS monitoring role (if enabled)"
  value       = var.enable_container_insights ? aws_iam_role.ecs_monitoring_role[0].name : null
}

################################################################################
# Convenience Outputs for ECS Service Configuration
################################################################################
output "service_task_roles" {
  description = "Map of service names to their task role ARNs for easy reference"
  value = {
    frontend = aws_iam_role.frontend_task_role.arn
    backend  = aws_iam_role.backend_task_role.arn
  }
}

output "all_task_role_arns" {
  description = "List of all task role ARNs created by this module"
  value = concat(
    [
      aws_iam_role.frontend_task_role.arn,
      aws_iam_role.backend_task_role.arn,
    ],
    length(var.custom_services) > 0 ? [for role in aws_iam_role.custom_service_task_role : role.arn] : [],
    var.enable_container_insights ? [aws_iam_role.ecs_monitoring_role[0].arn] : []
  )
}

output "all_role_names" {
  description = "List of all role names created by this module"
  value = concat(
    [
      aws_iam_role.ecs_task_execution_role.name,
      aws_iam_role.frontend_task_role.name,
      aws_iam_role.backend_task_role.name,
    ],
    length(var.custom_services) > 0 ? [for role in aws_iam_role.custom_service_task_role : role.name] : [],
    var.enable_container_insights ? [aws_iam_role.ecs_monitoring_role[0].name] : []
  )
}