data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# -------------------------
# Get public key from Secrets Manager
# -------------------------
data "aws_secretsmanager_secret_version" "s3_public_key" {
  secret_id = "${var.env}/${var.project}/cloudfront/s3/public_key"
}

# -------------------------
# CloudFront Public Key + Key Group
# -------------------------
resource "aws_cloudfront_public_key" "s3_key" {
  name        = "${var.env}-${var.project}-s3-key"
  encoded_key = data.aws_secretsmanager_secret_version.s3_public_key.secret_string
}

resource "aws_cloudfront_key_group" "s3_key_group" {
  name  = "${var.env}-${var.project}-s3-key-group"
  items = [aws_cloudfront_public_key.s3_key.id]
}

# -------------------------
# Origin Access Control (OAC) for S3
# -------------------------
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.env}-${var.project}-s3-oac"
  description                       = "OAC for S3 static files"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



# -------------------------
# VPC Origin for ALB
# -------------------------
resource "aws_cloudfront_vpc_origin" "alb_vpc_origin" {
  vpc_origin_endpoint_config {
    name                   = "${var.env}-${var.project}-alb-vpc-origin"
    arn                    = var.alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      quantity = 1
      items    = ["TLSv1.2"]
    }
  }
}

# -------------------------
# S3 CloudFront Distribution (Static Content)
# -------------------------
resource "aws_cloudfront_distribution" "s3" {
  enabled = true
  #aliases = [var.s3_custom_domain_name]
  comment = "${var.env}-${var.project} S3 CloudFront Distribution"

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = "S3-${var.env}-${var.project}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.env}-${var.project}"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
    compress               = true
    trusted_key_groups     = [aws_cloudfront_key_group.s3_key_group.id]
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.project}-cloudfront-s3" })
}

# -------------------------
# ALB CloudFront Distribution (Dynamic Content)
# -------------------------
resource "aws_cloudfront_distribution" "alb" {
  enabled = true
  #aliases    = [var.alb_custom_domain_name]
  comment    = "${var.env}-${var.project} ALB CloudFront Distribution"
  web_acl_id = var.web_acl_id

  origin {
    domain_name = var.alb_domain_name
    origin_id   = "ALB-${var.env}-${var.project}"

    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.alb_vpc_origin.id
    }

    custom_header {
      name  = "X-Custom-Header"
      value = var.cloudfront_security_header_value
    }
  }

  default_cache_behavior {
    target_origin_id       = "ALB-${var.env}-${var.project}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.project}-cloudfront-alb" })
}

resource "aws_s3_bucket_policy" "static_files" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_id}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3.arn
          }
        }
      }
    ]
  })
}