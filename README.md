# tf-modules-s3-bucket

```hcl
module "s3_bucket" {
  source         = "git::https://github.com/harmonate/tf-module-s3-bucket.git?ref=main"
  bucket_name    = "my-app"
  enable_versioning = true
  bucket_policy_principal = {
    AWS = "arn:aws:iam::123456789012:user/example"
  }
  bucket_policy_effect = "Allow"
  bucket_policy_action = ["s3:GetObject"]
  enable_logging = false   #optional - create a log bucket with same name as bucket + log
}
```

## outputs

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
