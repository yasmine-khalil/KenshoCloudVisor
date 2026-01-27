output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.arn
}

output "ecs_service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app_service.arn
}

output "ecs_service_desired_count" {
  description = "Desired count of tasks for the ECS service"
  value       = aws_ecs_service.app_service.desired_count
}

output "ecs_service_network_configuration" {
  description = "Network configuration of the ECS service"
  value       = aws_ecs_service.app_service.network_configuration
}

output "ecs_task_execution_role_arn" {
  description = "Execution role ARN for the ECS task"
  value       = aws_ecs_task_definition.app.execution_role_arn
}

output "ecs_task_role_arn" {
  description = "Task role ARN for the ECS task"
  value       = aws_ecs_task_definition.app.task_role_arn
}

output "ecs_task_family" {
  description = "Family name of the ECS task definition"
  value       = aws_ecs_task_definition.app.family
}
