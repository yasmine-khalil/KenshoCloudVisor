output "bucket_id" {
  value       = aws_s3_bucket.documents.id
  description = "ID of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.documents.arn
  description = "ARN of the S3 bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.documents.bucket_domain_name
  description = "Domain name of the S3 bucket"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.documents.bucket_regional_domain_name
  description = "Regional domain name of the S3 bucket"
}