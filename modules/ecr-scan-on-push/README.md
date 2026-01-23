# ecr-scan-on-push module

This module is used to create an AWS ECR repository and enable 'scan-on-push' feature for it.


## Version

1.0.0


## Table of Contents

- [ecr-scan-on-push module](#ecr-scan-on-push-module)
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
| var.repository_name | aws_ecr_repository |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_name | ECR repository name | string | - | Y |


## Outputs

| Name | Description |
|------|-------------|
| repository_url | URL of the ECR repository |
| repository_name | Name of the ECR repository |


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
