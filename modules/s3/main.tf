data "aws_caller_identity" "current" {}

# S3 bucket for static files
resource "aws_s3_bucket" "documents" {
  bucket = "${var.env}-${var.project}-${var.bucket_suffix}-${data.aws_caller_identity.current.account_id}"
  # lifecycle {
  #   ignore_changes = [
  #     policy
  #   ]
  # }
  tags = {
    Name = "${var.env}-${var.project}-${var.bucket_suffix}"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "documents" {
  bucket = aws_s3_bucket.documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "documents" {
  bucket = aws_s3_bucket.documents.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "documents" {
  bucket = aws_s3_bucket.documents.id

  rule {
    id     = "keep-last-10-total"
    status = "Enabled"

    noncurrent_version_expiration {
      # Keep 9 past versions + 1 current version = 10 total
      newer_noncurrent_versions = 9

      # Allow expiration as soon as possible (1 day after becoming noncurrent)
      noncurrent_days = 1
    }
  }
}