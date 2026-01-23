data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Generate private key
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create key pair
resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.env}-${var.project}-bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

# Store private key in Secrets Manager
resource "aws_secretsmanager_secret" "bastion_private_key" {
  name        = "${var.env}/${var.project}/bastion/private-key"
  description = "Private key for bastion host SSH access"
}

resource "aws_secretsmanager_secret_version" "bastion_private_key" {
  secret_id     = aws_secretsmanager_secret.bastion_private_key.id
  secret_string = tls_private_key.bastion_key.private_key_pem
}

# Security group for bastion host
resource "aws_security_group" "bastion" {
  name        = "${var.env}-${var.project}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.255.45.140/32"]
    description = "SSH from VPN"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.project}-bastion-sg"
  }
}

# IAM role for bastion host
resource "aws_iam_role" "bastion_role" {
  name = "${var.env}-${var.project}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM managed policy
resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.env}-${var.project}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bastion_key.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "${var.env}-${var.project}-bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  count    = var.create_elastic_ip ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.bastion.id

  tags = {
    Name = "${var.env}-${var.project}-bastion-eip"
  }

  depends_on = [aws_instance.bastion]
}