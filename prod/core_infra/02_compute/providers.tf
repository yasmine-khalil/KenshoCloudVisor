
terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.59.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-207933152498-eu-west-1"
    key            = "prod/core_infra/02_compute.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}


provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Project     = var.project
      ManagedBy   = "IAC Terraform"
    }
  }
}

