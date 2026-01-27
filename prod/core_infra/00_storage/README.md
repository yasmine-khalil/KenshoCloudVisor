
# networking module

This module is used to create <RESOURCES> resources in AWS.

**Important note!**

<PUT HERE IF THERE IS SOME IMPORTANT RESTRICTION OF USAGE>

## Version

1.0.0


## Table of Contents

- [networking module](#networking-module)
  - [Version](#version)
  - [Table of Contents](#table-of-contents)
  - [Used Modules](#used-modules)
  - [Created Resources](#created-resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Prerequisites](#prerequisites)
    - [Providers](#providers)
  - [Deployment](#deployment)
  - [Terraform Lifecycle Rules](#terraform-lifecycle-rules)
  - [Others](#others)


## Used Modules

| Name | Type |
|------|------|
| <MODULE_NAME> | <LINK_TO_MODULE_README> |


## Created Resources

| Name | Type |
|------|------|
| <RESOURCE_NAME> | <RESOURCE_TYPE> |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | Project name | string | - | Y |
| env | Environment name | string | dev | N |
| tags | A map of tags to use on all resources | map(string) | {} | N |


## Outputs

| Name | Description |
|------|-------------|
| <OUTPUT_NAME> | <OUTPUT_DESCRIPTION> |


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


## Others

<OTHER_RELEVANT_DETAILS>

