data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# VPC
################################################################################
resource "aws_vpc" "infra" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.env}-${var.project}"
  }
}

################################################################################
# Private subnets
################################################################################
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = replace(var.vpc_cidr, "0.0/16", "0.0/24")
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = replace(var.vpc_cidr, "0.0/16", "1.0/24")
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-${var.project}-private-subnet-b"
  }
}

################################################################################
# Public subnets
################################################################################
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = replace(var.vpc_cidr, "0.0/16", "2.0/24")
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${var.project}-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = replace(var.vpc_cidr, "0.0/16", "3.0/24")
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${var.project}-public-subnet-b"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.infra.id

  tags = {
    Name = "${var.env}-${var.project}-igw"
  }
}

################################################################################
# NAT Gateway (Single)
################################################################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "${var.env}-${var.project}-natgw"
  }
  depends_on = [aws_eip.eip]
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-${var.project}-natgw-eip"
  }
}

################################################################################
# Route Tables
################################################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.infra.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-${var.project}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.infra.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.env}-${var.project}-private-rt"
  }
}

################################################################################
# Route Table Associations
################################################################################
resource "aws_route_table_association" "public_rt_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}

################################################################################
# Security Group
################################################################################
resource "aws_security_group" "vpc_internal" {
  name        = "${var.env}-${var.project}-vpc_internal"
  description = "Allow all internal inbound traffic"
  vpc_id      = aws_vpc.infra.id

  ingress {
    description = "All from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.infra.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-${var.project}-vpc-internal"
  }
}
