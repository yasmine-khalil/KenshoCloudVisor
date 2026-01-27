####################################################################
# AWS Guardduty
####################################################################
resource "aws_guardduty_detector" "default_detector" {
  enable = var.enable_guard_duty # FLOW_LOGS, DNS_LOGS, CLOUD_TRAIL
}

resource "aws_guardduty_detector_feature" "eks_protection" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "EKS_AUDIT_LOGS"
  status      = var.extra_feature_eks_protection == true ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "eks_runtime_monitoring" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "EKS_RUNTIME_MONITORING"
  status      = var.extra_feature_eks_runtime_monitoring == true ? "ENABLED" : "DISABLED"

  dynamic "additional_configuration" {
    for_each = var.extra_feature_eks_runtime_monitoring ? [1] : []
    content {
      name   = "EKS_ADDON_MANAGEMENT"
      status = "ENABLED"
    }
  }

  lifecycle {
    ignore_changes = [additional_configuration]
  }
}

resource "aws_guardduty_detector_feature" "runtime_monitoring" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "RUNTIME_MONITORING"
  status      = var.extra_feature_runtime_monitoring == true ? "ENABLED" : "DISABLED"

  dynamic "additional_configuration" {
    for_each = var.extra_feature_runtime_monitoring ? [1] : []
    content {
      name   = "EKS_ADDON_MANAGEMENT"
      status = "ENABLED"
    }
  }

  dynamic "additional_configuration" {
    for_each = var.extra_feature_runtime_monitoring ? [1] : []
    content {
      name   = "ECS_FARGATE_AGENT_MANAGEMENT"
      status = "ENABLED"
    }
  }

  dynamic "additional_configuration" {
    for_each = var.extra_feature_runtime_monitoring ? [1] : []
    content {
      name   = "EC2_AGENT_MANAGEMENT"
      status = "ENABLED"
    }
  }

  lifecycle {
    ignore_changes = [additional_configuration]
  }
}

resource "aws_guardduty_detector_feature" "lambda_protection" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "LAMBDA_NETWORK_LOGS"
  status      = var.extra_feature_lambda_protection == true ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "rds_protection" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "RDS_LOGIN_EVENTS"
  status      = var.extra_feature_rds_protection == true ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.default_detector.id
  name        = "S3_DATA_EVENTS"
  status      = var.extra_feature_s3_protection == true ? "ENABLED" : "DISABLED"
}
