# cloudfront module

This module is used to create a CloudFront distribution with internal ALB and S3 origins, implementing proper caching strategies and security headers.

**Important note!**

SSL terminates on CloudFront. Internal ALB origin uses HTTP-only with security headers for VPC access. S3 uses OAC for secure access.

## Version

1.0.0

## Table of Contents

- [cloudfront module](#cloudfront-module)
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
| "${var.env}-${var.project}-s3-key" | aws_cloudfront_public_key |
| "${var.env}-${var.project}-s3-key-group" | aws_cloudfront_key_group |
| "${var.env}-${var.project}-s3-oac" | aws_cloudfront_origin_access_control |
| "${var.env}-${var.project}-alb-vpc-origin" | aws_cloudfront_vpc_origin |
| "${var.env}-${var.project}-cloudfront-s3" | aws_cloudfront_distribution (S3) |
| "${var.env}-${var.project}-cloudfront-alb" | aws_cloudfront_distribution (ALB) |
| S3 bucket policy | aws_s3_bucket_policy |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| s3_custom_domain_name | Domain name for S3 CloudFront distribution | string | "" | N |
| alb_custom_domain_name | Domain name for ALB CloudFront distribution | string | "" | N |
| acm_certificate_arn | ACM certificate ARN in us-east-1 region | string | - | Y |
| alb_domain_name | Internal ALB domain name for dynamic content origin | string | - | Y |
| alb_arn | ARN of the internal ALB for VPC origin | string | - | Y |
| vpc_id | VPC ID where the internal ALB is located | string | - | Y |
| s3_bucket_domain_name | S3 bucket regional domain name | string | - | Y |
| s3_bucket_id | S3 bucket ID for OAC policy | string | - | Y |
| upload_path_pattern | Path pattern for uploaded images | string | /upload/* | N |
| web_acl_id | WAF Web ACL ID to associate with distributions | string | null | N |
| tags | A map of tags to use on all resources | map(string) | {} | N |

## Outputs

| Name | Description |
|------|-------------|
| s3_distribution_id | ID of the S3 CloudFront distribution |
| s3_distribution_arn | ARN of the S3 CloudFront distribution |
| s3_distribution_domain_name | Domain name of the S3 CloudFront distribution |
| alb_distribution_id | ID of the ALB CloudFront distribution |
| alb_distribution_arn | ARN of the ALB CloudFront distribution |
| alb_distribution_domain_name | Domain name of the ALB CloudFront distribution |
| oac_id | ID of the Origin Access Control for S3 |
| vpc_origin_id | ID of the VPC origin for internal ALB |

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