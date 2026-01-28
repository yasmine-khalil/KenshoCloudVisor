####################################################################
# CLEAN ECS Cluster Module - Single Responsibility
####################################################################
# This module ONLY creates an ECS cluster with basic configuration.
# Task definitions, services, IAM roles belong in separate modules.
####################################################################

resource "aws_ecs_cluster" "this" {
  name = var.name

  tags = merge(var.tags, {
    Name        = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}
