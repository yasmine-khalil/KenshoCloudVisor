################################################################################
# WAF Web ACL
################################################################################
resource "aws_wafv2_web_acl" "main" {
  count = var.create_waf && var.scope == "REGIONAL" ? 1 : 0

  name  = "${var.env}-${var.project}-waf"
  scope = var.scope

  default_action {
    allow {}
  }

  # Core Rule Set (CRS)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.env}-${var.project}-CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.env}-${var.project}-KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.env}-${var.project}-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.env}-${var.project}-waf"
  }
}

resource "aws_wafv2_web_acl" "cloudfront" {
  count    = var.create_waf && var.scope == "CLOUDFRONT" ? 1 : 0
  provider = aws.us_east_1

  name  = "${var.env}-${var.project}-waf"
  scope = var.scope

  default_action {
    allow {}
  }

  # Core Rule Set (CRS)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.env}-${var.project}-CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.env}-${var.project}-KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.env}-${var.project}-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.env}-${var.project}-waf"
  }
}

################################################################################
# WAF Association
################################################################################
resource "aws_wafv2_web_acl_association" "main" {
  count = var.create_waf && var.resource_arn != null && var.scope == "REGIONAL" ? 1 : 0

  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.main[0].arn
}
