data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# -------------------------
# ALB CloudFront Distribution (No Caching)
# -------------------------
resource "aws_cloudfront_distribution" "alb" {
  enabled    = true
  comment    = "${var.env}-${var.project} ALB CloudFront Distribution - No Caching"
  web_acl_id = var.web_acl_id

  origin {
    domain_name = var.alb_domain_name
    origin_id   = "ALB-${var.env}-${var.project}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  default_cache_behavior {
    target_origin_id         = "ALB-${var.env}-${var.project}"
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin
    compress                 = true

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.project}-cloudfront-alb" })
}