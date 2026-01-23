data "aws_caller_identity" "current" {}

# S3 bucket for static files
resource "aws_s3_bucket" "static_files" {
  bucket = "${var.env}-${var.project}-${var.bucket_suffix}-${data.aws_caller_identity.current.account_id}"
  lifecycle {
    ignore_changes = [
      policy
    ]
  }
  tags = {
    Name = "${var.env}-${var.project}-${var.bucket_suffix}"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "static_files" {
  bucket = aws_s3_bucket.static_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "static_files" {
  bucket = aws_s3_bucket.static_files.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "static_files" {
  bucket = aws_s3_bucket.static_files.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}