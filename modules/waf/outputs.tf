output "web_acl_id" {
  value       = var.scope == "CLOUDFRONT" ? try(aws_wafv2_web_acl.cloudfront[0].id, null) : try(aws_wafv2_web_acl.main[0].id, null)
  description = "The ID of the WAF Web ACL"
}

output "web_acl_arn" {
  value       = var.scope == "CLOUDFRONT" ? try(aws_wafv2_web_acl.cloudfront[0].arn, null) : try(aws_wafv2_web_acl.main[0].arn, null)
  description = "The ARN of the WAF Web ACL"
}

output "web_acl_capacity" {
  value       = var.scope == "CLOUDFRONT" ? try(aws_wafv2_web_acl.cloudfront[0].capacity, null) : try(aws_wafv2_web_acl.main[0].capacity, null)
  description = "The capacity units used by the WAF Web ACL"
}
