output "bucket_id" {
  value       = aws_s3_bucket.static_files.id
  description = "ID of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.static_files.arn
  description = "ARN of the S3 bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.static_files.bucket_domain_name
  description = "Domain name of the S3 bucket"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.static_files.bucket_regional_domain_name
  description = "Regional domain name of the S3 bucket"
}