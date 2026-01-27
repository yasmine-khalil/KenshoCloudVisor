locals {
  bucket_name = "${var.env}-${var.project}-cloudtrail-${data.aws_caller_identity.current.account_id}"
}

####################################################################
# AWS Cloudtrail
####################################################################
# Create S3 bucket
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = local.bucket_name
  force_destroy = false
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    id     = "delete_logs_after_365_days"
    status = "Enabled"

    expiration {
      days = 365
    }
  }
}

# Optional access logging bucket
resource "aws_s3_bucket" "access_logging_bucket" {
  count         = var.enable_access_logging ? 1 : 0
  bucket        = "${local.bucket_name}-access-logs"
  force_destroy = false
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "access_logging_bucket" {
  count  = var.enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logging_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logging_bucket" {
  count  = var.enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logging_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_logging" "cloudtrail_bucket" {
  count  = var.enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  target_bucket = aws_s3_bucket.access_logging_bucket[0].id
  target_prefix = "cloudtrail-access-logs/"
}

# S3 bucket policy
data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/${var.env}-${var.project}"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_bucket.arn}${var.s3_key_prefix != "" ? "/${var.s3_key_prefix}" : ""}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/${var.env}-${var.project}"]
    }
  }

}

# Enable S3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
}

# Cloudtrail
resource "aws_cloudtrail" "cloudtrail" {
  depends_on = [aws_s3_bucket_policy.s3_bucket_policy]

  name                          = "${var.env}-${var.project}"
  enable_logging                = var.enable_logging
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = var.s3_key_prefix
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  tags = var.tags
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}
