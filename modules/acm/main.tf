# Regional certificate
resource "aws_acm_certificate" "regional" {
  count = var.create_regional_cert ? 1 : 0

  domain_name               = var.domain_names[0]
  subject_alternative_names = length(var.domain_names) > 1 ? slice(var.domain_names, 1, length(var.domain_names)) : []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.env}-${var.project}-regional-cert"
  }
}

# US East 1 certificate (conditional)
resource "aws_acm_certificate" "us_east_1" {
  count = var.create_us_east_1_cert ? 1 : 0

  provider                  = aws.us_east_1
  domain_name               = var.domain_names[0]
  subject_alternative_names = length(var.domain_names) > 1 ? slice(var.domain_names, 1, length(var.domain_names)) : []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.env}-${var.project}-us-east-1-cert"
  }
}