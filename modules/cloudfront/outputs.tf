output "s3_distribution_id" {
  value       = aws_cloudfront_distribution.s3.id
  description = "ID of the S3 CloudFront distribution"
}

output "s3_distribution_arn" {
  value       = aws_cloudfront_distribution.s3.arn
  description = "ARN of the S3 CloudFront distribution"
}

output "s3_distribution_domain_name" {
  value       = aws_cloudfront_distribution.s3.domain_name
  description = "Domain name of the S3 CloudFront distribution"
}

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

output "vpc_origin_id" {
  value       = aws_cloudfront_vpc_origin.alb_vpc_origin.id
  description = "ID of the VPC origin for internal ALB"
}