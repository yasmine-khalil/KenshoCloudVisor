# 3tier-vpc-co module

This module is used to create a cost optimized 3-tier VPC resource in AWS.
Not fully highly available, only one NAT GW is created and 2 subnets per AZ.

**Important note!**

For VPC CIDR input variable something like "X.X.0.0/16" is expected.
It will be created 6 subnets with simple string replace - replaces last "0.0/16" part of cidr block with "[0-5].0/24"

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [3tier-vpc-co module](#3tier-vpc-co-module)
  - [Version](#version)
  - [Table of Contents](#table-of-contents)
  - [Created Resources](#created-resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Prerequisites](#prerequisites)
    - [Providers](#providers)
  - [Deployment](#deployment)
  - [Terraform Lifecycle Rules](#terraform-lifecycle-rules)


## Created Resources

| Name | Type |
|------|------|
| "${var.env}-${var.project}" | AWS VPC |
| "${var.env}-${var.project}-app-subnet-a" | NAT-ted subnet in az A |
| "${var.env}-${var.project}-app-subnet-b" | NAT-ted subnet in az B |
| "${var.env}-${var.project}-db-subnet-a" | Private subnet in az A |
| "${var.env}-${var.project}-db-subnet-b" | Private subnet in az B |
| "${var.env}-${var.project}-public-subnet-a" | Public subnet in az A |
| "${var.env}-${var.project}-public-subnet-b" | Public subnet in az B |
| "${var.env}-${var.project}-igw" | Internet gateway |
| "${var.env}-${var.project}-natgw-a" | NAT gateway in az A |
| eip_a | Elastic IP to use with the NAT GW |
| "${env}-${project}-igw-rt" | Route table for public subnets |
| "${env}-${project}-nat-rt" | Route table for app subnets |
| "${env}-${project}-private-rt" | Route table for db subnets |
| "${env}-${project}-vpc-internal" | Security Group that enables VPC internal TCP communication, and all outbound traffic |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr | CIDR block for VPC | string | 10.20.0.0/16 | N |
| project | Project name | string | network | N |
| env | Environment name | string | dev | N |


## Outputs

| Name | Description |
|------|-------------|
| vpc_id | Id of VPC created |
| vpc_cidr | CIDR range of VPC |
| app_private_subnet_a_id | Id of app subnet in az A |
| app_private_subnet_b_id | Id of app subnet in az B |
| db_private_subnet_a_id | Id of db subnet in az A |
| db_private_subnet_b_id | Id of db subnet in az B |
| public_subnet_a_id | Id of public subnet in az A |
| public_subnet_b_id | Id of public subnet in az B |
| vpc_internal_sg_id | Id of vpc internal security group |


## Prerequisites

Terraform version: >= 1.9.0

### Providers

| Name | Version |
|------|---------|
| aws  | >= 5.59.0 |


## Deployment

To run this code you need to execute:

```sh
terraform init
terraform plan
terraform apply
```

## Terraform lifecycle rules

Not applied any.
