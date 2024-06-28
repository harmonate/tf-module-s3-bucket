output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this_bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this_bucket.arn
}

output "log_bucket_name" {
  description = "The name of the log S3 bucket"
  value       = var.enable_logging ? local.log_bucket_name : null
}

output "log_bucket_arn" {
  description = "The ARN of the log S3 bucket"
  value       = var.enable_logging ? aws_s3_bucket.log_bucket[0].arn : null
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.this_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this_bucket.bucket_regional_domain_name
}
