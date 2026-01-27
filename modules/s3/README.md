# s3 module

This module is used to create an S3 bucket for static files with CloudFront OAC access policy and blocked public access.

**Important note!**

The bucket has all public access blocked and can only be accessed via CloudFront distributions using Origin Access Control (OAC).

## Version

1.0.0

## Table of Contents

- [s3 module](#s3-module)
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
| "${var.env}-${var.project}-${var.bucket_suffix}-${account_id}" | aws_s3_bucket |
| static_files | aws_s3_bucket_public_access_block |
| static_files | aws_s3_bucket_versioning |
| static_files | aws_s3_bucket_server_side_encryption_configuration |
| static_files | aws_s3_bucket_policy |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| bucket_suffix | Suffix for bucket name to ensure uniqueness | string | static-files | N |
| enable_versioning | Enable versioning for S3 bucket | bool | true | N |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | ID of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |
| bucket_domain_name | Domain name of the S3 bucket |
| bucket_regional_domain_name | Regional domain name of the S3 bucket |

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
terraform apply --auto-approve
```

## Terraform Lifecycle Rules

There is not applied any.