# guard-duty module

This module is used to enable AWS GuardDuty (under the hood a GuardDuty detector is created in AWS).
All additional features (protections) are disabled, but can be anbled via variables.

**Important note!**

Additional features `extra_feature_runtime_monitoring` and `extra_feature_eks_runtime_monitoring` - only one of them can be added, adding both features will cause an error (`extra_feature_runtime_monitoring` includes the feature set from the other).

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [guard-duty module](#guard-duty-module)
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
| GuardDuty detector | When GuardDuty enabled it creates a detector for the AWS account in the region |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_guard_duty | Enable GuardDuty | bool | true | N |
| extra_feature_eks_protection | Enable EKS audit logs | bool | false | N |
| extra_feature_eks_runtime_monitoring | Enable full EKS runtime monitoring | bool | false | N |
| extra_feature_runtime_monitoring | Enable full runtime monitoring (this includes full eks runtime monitoring) | bool | false | N |
| extra_feature_lambda_protection | Enable lambda network logs | bool | false | N |
| extra_feature_rds_protection | Enable RDS login events | bool | false | N |
| extra_feature_s3_protection | Enable S3 data events | bool | false | N |


## Outputs

| Name | Description |
|------|-------------|
| guard_duty_detector_id | GuardDuty detector id |
| guard_duty_enabled | GuardDuty enabled |



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
