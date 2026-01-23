output "cloudtrail_name" {
  description = "Name of the created Trail"
  value       = aws_cloudtrail.cloudtrail.name
}

output "cloudtrail_bucket_name" {
  description = "Name of the bucket that stores the logs from the trail"
  value       = aws_s3_bucket.cloudtrail_bucket.bucket
}
