# output "regional_certificate_arn" {
#   value       = var.create_regional_cert ? aws_acm_certificate.regional.arn[0] : null
#   description = "ARN of the regional ACM certificate"
# }

# output "regional_certificate_domain_validation_options" {
#   value       = aws_acm_certificate.regional.domain_validation_options
#   description = "Domain validation options for regional certificate"
# }

output "us_east_1_certificate_arn" {
  value       = var.create_us_east_1_cert ? aws_acm_certificate.us_east_1[0].arn : null
  description = "ARN of the US East 1 ACM certificate (null if not created)"
}

output "us_east_1_certificate_domain_validation_options" {
  value       = var.create_us_east_1_cert ? aws_acm_certificate.us_east_1[0].domain_validation_options : null
  description = "Domain validation options for US East 1 certificate (null if not created)"
}