# bastion-host module

This module is used to create a bastion host in a public subnet with SSH access via key pair and Systems Manager.

**Important note!**

The private key is automatically generated and stored in AWS Secrets Manager for secure access.

## Version

1.0.0

## Table of Contents

- [bastion-host module](#bastion-host-module)
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
| "${var.env}-${var.project}-bastion" | aws_instance |
| "${var.env}-${var.project}-bastion-key" | aws_key_pair |
| "${var.env}-${var.project}-bastion-private-key" | aws_secretsmanager_secret |
| "${var.env}-${var.project}-bastion-sg" | aws_security_group |
| "${var.env}-${var.project}-bastion-role" | aws_iam_role |
| "${var.env}-${var.project}-bastion-profile" | aws_iam_instance_profile |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| vpc_id | VPC ID where bastion host will be deployed | string | - | Y |
| public_subnet_id | Public subnet ID for bastion host placement | string | - | Y |
| instance_type | EC2 instance type for bastion host | string | t3.micro | N |
| create_elastic_ip | Whether to create and attach an Elastic IP | bool | false | N |

## Outputs

| Name | Description |
|------|-------------|
| bastion_instance_id | ID of the bastion host instance |
| bastion_public_ip | Public IP address of the bastion host (Elastic IP if enabled) |
| bastion_elastic_ip | Elastic IP address of the bastion host (null if not created) |
| bastion_private_ip | Private IP address of the bastion host |
| bastion_security_group_id | ID of the bastion host security group |
| private_key_secret_arn | ARN of the Secrets Manager secret containing the private key |
| key_pair_name | Name of the EC2 key pair |

## Prerequisites

Terraform version: >= 1.9.0

### Providers

| Name | Version |
|------|---------|
| aws  | >= 5.59.0 |
| tls  | >= 3.0.0 |

## Deployment

To run this code you need to execute:

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

## Terraform Lifecycle Rules

There is not applied any.