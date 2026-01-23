output "guard_duty_detector_id" {
  description = "GuardDuty detector id"
  value       = aws_guardduty_detector.default_detector.id
}

output "guard_duty_enabled" {
  description = "GuardDuty enabled"
  value       = aws_guardduty_detector.default_detector.enable
}
