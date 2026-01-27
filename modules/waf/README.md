# waf module

This module is used to create an AWS WAF Web ACL with baseline managed rule groups for CloudFront and ALB protection.

**Important note!**

The WAF is deployed in COUNT mode initially. This allows monitoring of traffic patterns without blocking legitimate requests. Once the client has reviewed the metrics and is confident in the rule configuration, they should update the override_action from `count {}` to `none {}` to enforce blocking.

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [waf module](#waf-module)
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
| "${var.env}-${var.project}-waf" | AWS WAFv2 Web ACL |
| AWSManagedRulesCommonRuleSet | Managed Rule Group (COUNT mode) |
| AWSManagedRulesKnownBadInputsRuleSet | Managed Rule Group (COUNT mode) |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment name | string | - | Y |
| project | Project name | string | - | Y |
| scope | WAF scope (CLOUDFRONT or REGIONAL) | string | - | Y |
| create_waf | Whether to create the WAF Web ACL | bool | true | N |
| resource_arn | ARN of CloudFront/ALB to associate | string | null | N |


## Outputs

| Name | Description |
|------|-------------|
| web_acl_id | The ID of the WAF Web ACL |
| web_acl_arn | The ARN of the WAF Web ACL |
| web_acl_capacity | The capacity units used by the WAF Web ACL |


## Prerequisites

Terraform version: >= 1.9.0

### Providers

| Name | Version |
|------|------------|
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
