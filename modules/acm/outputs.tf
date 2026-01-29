output "alb_certificate_arn" {
  value       = aws_acm_certificate.alb_certificate.arn
  description = "ARN of the ALB ACM certificate"
}

output "us_east_1_certificate_arn" {
  value       = aws_acm_certificate.cloudfront_certificate.arn
  description = "ARN of the Cloudfront ACM certificate"
}
