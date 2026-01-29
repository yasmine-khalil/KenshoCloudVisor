# ALB certificate
resource "aws_acm_certificate" "alb_certificate" {

  domain_name               = var.alb_certificate_domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-alb-cert"
  })  
}

# US East 1 certificate
resource "aws_acm_certificate" "cloudfront_certificate" {

  provider                  = aws.us_east_1
  domain_name               = var.cloudfront_certificate_domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-cloudfront-cert"
  })    
}