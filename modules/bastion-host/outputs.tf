output "bastion_instance_id" {
  value       = aws_instance.bastion.id
  description = "ID of the bastion host instance"
}

output "bastion_public_ip" {
  value       = var.create_elastic_ip ? (length(aws_eip.bastion_eip) > 0 ? aws_eip.bastion_eip[0].public_ip : null) : aws_instance.bastion.public_ip
  description = "Public IP address of the bastion host (Elastic IP if enabled, otherwise instance IP)"
}

output "bastion_elastic_ip" {
  value       = var.create_elastic_ip ? (length(aws_eip.bastion_eip) > 0 ? aws_eip.bastion_eip[0].public_ip : null) : null
  description = "Elastic IP address of the bastion host (null if not created)"
}

output "bastion_private_ip" {
  value       = aws_instance.bastion.private_ip
  description = "Private IP address of the bastion host"
}

output "bastion_security_group_id" {
  value       = aws_security_group.bastion.id
  description = "ID of the bastion host security group"
}

output "private_key_secret_arn" {
  value       = aws_secretsmanager_secret.bastion_private_key.arn
  description = "ARN of the Secrets Manager secret containing the private key"
}

output "key_pair_name" {
  value       = aws_key_pair.bastion_key.key_name
  description = "Name of the EC2 key pair"
}