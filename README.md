# tf-modules-s3-bucket

This example creates an S3 bucket with the following configuration:
- Bucket name will be "my-application-data-bucket-[random_suffix]"
- Versioning is enabled
- Logging is enabled (creates a separate log bucket)
- A bucket policy allowing a specific IAM user to get objects and list the bucket
- A lifecycle rule to expire objects in the "logs/" prefix after 90 days

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | The name of the bucket | `string` | n/a | yes |
| enable_versioning | Enable versioning for the bucket | `bool` | `false` | no |
| enable_logging | Enable logging for the S3 bucket | `bool` | `false` | no |
| bucket_policy_principal | The principal for the bucket policy | `map(string)` | `{ "AWS" = "*" }` | no |
| bucket_policy_effect | The effect for the bucket policy | `string` | `"Allow"` | no |
| bucket_policy_action | The action for the bucket policy | `list(string)` | n/a | yes |
| lifecycle_rules | List of lifecycle rules to configure for the S3 bucket | `list(object)` | `[]` | no |


## Usage

```hcl
module "s3_bucket" {
  source         = "git::https://github.com/harmonate/tf-module-s3-bucket.git?ref=main"
  bucket_name    = "my-app"
  enable_versioning = true
  bucket_policy_principal = {
    AWS = "arn:aws:iam::123456789012:user/example"
  }
  bucket_policy_effect = "Allow"
  bucket_policy_action = [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:ListAllMyBuckets"
  ]
  lifecycle_rules = [
    {
      id = "archive-after-30-days"
      enabled = true
      prefix = "logs/"
      expiration = {
        days = 30
      }
    }
  ]
  enable_logging = false   #optional - create a log bucket with same name as bucket + log
}
```

## Outputs

```hcl
output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "log_bucket_name" {
  value = module.s3_bucket.log_bucket_name
}

output "log_bucket_arn" {
  value = module.s3_bucket.log_bucket_arn
}

output "bucket_domain_name" {
  value = module.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = module.s3_bucket.bucket_regional_domain_name
}
```
