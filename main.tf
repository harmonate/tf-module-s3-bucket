locals {
  this_bucket_name = "${var.bucket_name}-bucket-${random_string.suffix.result}"
  log_bucket_name  = "${var.bucket_name}-log-bucket-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
  lower   = true
}

resource "aws_s3_bucket" "this_bucket" {
  bucket        = local.this_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "log_bucket" {
  count         = var.enable_logging ? 1 : 0
  bucket        = local.log_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this_bucket_ownership" {
  bucket = aws_s3_bucket.this_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.this_bucket_ownership]

  bucket = aws_s3_bucket.this_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this_bucket_versioning" {
  bucket = aws_s3_bucket.this_bucket.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_logging" "this_bucket_logging" {
  count    = var.enable_logging ? 1 : 0
  bucket   = aws_s3_bucket.this_bucket.id
  target_bucket = var.enable_logging
  target_prefix = "${local.this_bucket_name}/"
}

resource "aws_s3_bucket_public_access_block" "this_bucket_public_access_block" {
  bucket   = aws_s3_bucket.this_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  bucket   = aws_s3_bucket.this_bucket.id
  policy   = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = var.bucket_policy_effect,
        Principal = var.bucket_policy_principal,
        Action = var.bucket_policy_action,
        Resource = [
          aws_s3_bucket.this_bucket.arn,
          "${aws_s3_bucket.this_bucket.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_s3_bucket_policy" "log_bucket_policy" {
  count    = var.enable_logging ? 1 : 0
  bucket   = local.log_bucket_name
  policy   = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudtrail.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = [
          "${aws_s3_bucket.log_bucket[count.index].arn}/*"
        ],
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = [
          "${aws_s3_bucket.log_bucket[count.index].arn}/*"
        ],
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}
