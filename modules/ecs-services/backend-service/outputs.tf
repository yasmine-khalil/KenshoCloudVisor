output "task_definition_arn" {
  description = "ARN of the app service task definition"
  value       = aws_ecs_task_definition.backend.arn
}

output "service_arn" {
  description = "ARN of the app service"
  value       = aws_ecs_service.backend.arn
}

output "service_name" {
  description = "Name of the app service"
  value       = aws_ecs_service.backend.name
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.backend.name
}

output "backend_security_group_id" {
  description = "Security Group ID of the ECS Service"
  value       = aws_security_group.ecs_sg_backend.id
}