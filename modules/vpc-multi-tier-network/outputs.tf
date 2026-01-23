output "vpc_id" {
  value = aws_vpc.infra.id
}

output "vpc_cidr" {
  value = aws_vpc.infra.cidr_block
}

output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "vpc_internal_sg_id" {
  value = aws_security_group.vpc_internal.id
}
