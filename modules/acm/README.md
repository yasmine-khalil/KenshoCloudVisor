# acm module

This module is used to create ACM SSL certificates with DNS validation in specified region and optionally in us-east-1.

**Important note!**

The us-east-1 certificate is conditionally created and is typically required for CloudFront distributions.
DNS validation records must be manually added to your DNS provider.

## Version

1.0.0

## Table of Contents

- [acm module](#acm-module)
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
| "${var.env}-${var.project}-regional-cert" | aws_acm_certificate |
| "${var.env}-${var.project}-us-east-1-cert" | aws_acm_certificate (conditional) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| region | AWS region for regional certificate | string | - | Y |
| domain_names | List of FQDNs for SSL certificate | list(string) | - | Y |
| create_us_east_1_cert | Whether to create certificate in us-east-1 region | bool | false | N |
| create_regional_cert | Whether to create certificate in specific region | bool | false | N |

## Outputs

| Name | Description |
|------|-------------|
| us_east_1_certificate_arn | ARN of the US East 1 ACM certificate |
| us_east_1_certificate_domain_validation_options | Domain validation options for US East 1 certificate |

## Prerequisites

Terraform version: >= 1.9.0

### Providers

| Name | Version |
|------|---------|
| aws  | >= 5.59.0 |
| aws.us_east_1 | >= 5.59.0 (alias for us-east-1 region) |

## Deployment

To run this code you need to execute:

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

## Terraform Lifecycle Rules

create_before_destroy = true is applied to prevent certificate deletion before replacement.