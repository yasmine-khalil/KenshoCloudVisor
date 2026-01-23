output "alb_distribution_id" {
  value       = aws_cloudfront_distribution.alb.id
  description = "ID of the ALB CloudFront distribution"
}

output "alb_distribution_arn" {
  value       = aws_cloudfront_distribution.alb.arn
  description = "ARN of the ALB CloudFront distribution"
}

output "alb_distribution_domain_name" {
  value       = aws_cloudfront_distribution.alb.domain_name
  description = "Domain name of the ALB CloudFront distribution"
}
