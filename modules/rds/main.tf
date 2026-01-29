#################################################################
# Security group
#################################################################
resource "aws_security_group" "db_security_group" {
  name        = "${var.env}-${var.project}-postgres-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-postgres-sg"
    Type = "RDS-PostgreSQL"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.db_security_group.id

  from_port   = 5432
  to_port     = 5432
  cidr_ipv4   = var.vpc_cidr # Allow everything within the VPC
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description       = "Allow everything out"
}

#################################################################
# DB Parameter group
#################################################################
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${var.env}-${var.project}-postgres-parameter-group"
  family      = "postgres18"
  description = "Postgres parameter group"

  # parameter {
  #   apply_method = "pending-reboot"
  #   name         = "rds.force_ssl"
  #   value        = "1"
  # }
}

#################################################################
# Subnet group
#################################################################
resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "${var.env}-${var.project}-rds-subnet-group"
  subnet_ids = [var.db_private_subnet_a_id, var.db_private_subnet_b_id]
}

#################################################################
# RDS Posgres DB
#################################################################
resource "aws_db_instance" "postgres_db" {
  identifier                  = "${var.env}-${var.project}-postgres-db"
  engine                      = "postgres"
  engine_version              = var.DB_engine_version
  instance_class              = var.DB_instance_type
  allocated_storage           = var.DB_allocated_storage
  max_allocated_storage       = 1000 # max storage size to scale up to.
  db_name                     = var.DB_database_name
  storage_type                = "gp3"
  username                    = var.DB_master_username
  manage_master_user_password = true
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = var.DB_backup_retention_period
  backup_window               = var.DB_preferred_backup_window
  apply_immediately           = true
  storage_encrypted           = true
  deletion_protection         = var.DB_deletion_protection
  db_subnet_group_name        = aws_db_subnet_group.rds_db_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.db_security_group.id]
  parameter_group_name        = aws_db_parameter_group.db_parameter_group.name

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-postgres-db"
    Type = "RDS-PostgreSQL"
  })
}