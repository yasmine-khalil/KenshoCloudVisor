# cloudtrail module

This module is used to create a CloudTrail in the desired region in AWS. By default it is a single-region trail, but multi-region event-collection can be turn on.
Logs stored in s3 bucket - it is created as well with necessary bucket policy added to the bucket.

**Important note!**

All management events are collected and sent to s3. You can enable/disable the trail.

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [cloudtrail module](#cloudtrail-module)
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
| "${var.env}-${var.project}" | The created Trail |
| "${var.env}-${var.project}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}" | S3 bucket that stores the logs from the trail |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | Project name | string | cloudtrail | N |
| env | Environment name | string | dev | N |
| tags | A map of tags to use on all resources | map(string) | {} | N |
| enable_logging | Enable/disable logging for the trail | bool | true | N |
| enable_multi_region | Convert trail to multi-region | bool | false | N |
| s3_key_prefix | S3 key prefix in bucket where logs go | string | "" | N |



## Outputs

| Name | Description |
|------|-------------|
| cloudtrail_name | Name of the created Trail |
| cloudtrail_bucket_name | Name of the bucket that stores the logs from the trail |


## Prerequisites

Terraform version: >= 1.9.0

### Providers

| Name | Version |
|------|---------|
| aws  | >= 6.12.0 |


## Deployment

To run this code you need to execute:

```sh
terraform init
terraform plan
terraform apply --auto-approve
```


## Terraform Lifecycle Rules

There is not applied any.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_kms_alias.cloudtrail_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudtrail_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.access_logging_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.access_logging_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.access_logging_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.cloudtrail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudtrail_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a new KMS key for CloudTrail encryption | `bool` | `true` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Enable access logging for the CloudTrail S3 bucket | `bool` | `false` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable/disable logging for the trail | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | dev, prod, stage, test, etc. /it is used to create unique resource names/ | `string` | `"dev"` | no |
| <a name="input_kms_deletion_window"></a> [kms\_deletion\_window](#input\_kms\_deletion\_window) | Number of days to retain the KMS key before deletion | `number` | `10` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Existing KMS key ID for CloudTrail encryption (used when create\_kms\_key is false) | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project /it is used to create unique resource names/ | `string` | `"cloudtrail"` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | S3 key prefix in bucket where logs go | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_use_kms_encryption"></a> [use\_kms\_encryption](#input\_use\_kms\_encryption) | Enable KMS encryption for CloudTrail logs | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#output\_cloudtrail\_bucket\_name) | Name of the bucket that stores the logs from the trail |
| <a name="output_cloudtrail_name"></a> [cloudtrail\_name](#output\_cloudtrail\_name) | Name of the created Trail |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS key ARN used for CloudTrail encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS key ID used for CloudTrail encryption |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
