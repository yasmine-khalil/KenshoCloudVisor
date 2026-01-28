output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.alb.zone_id
}

output "frontend_target_group_arn" {
  description = "ARN of the target group of the frontend service"
  value       = aws_lb_target_group.tg.arn
}

output "backend_target_group_arn" {
  description = "ARN of the target group of the backend service"
  value       = aws_lb_target_group.tg_3000.arn
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.certificate_arn != null ? aws_lb_listener.https[0].arn : null
}