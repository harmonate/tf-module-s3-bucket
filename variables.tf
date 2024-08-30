variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "bucket_policy_principal" {
  description = "The principal for the bucket policy"
  type        = map(string)
  default     = {
    "AWS" = "*"
  }
}

variable "bucket_policy_effect" {
  description = "The effect for the bucket policy"
  type        = string
  default     = "Allow"
}

variable "bucket_policy_action" {
  description = "The action for the bucket policy"
  type        = list(string)
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to configure for the S3 bucket"
  type = list(object({
    id      = string
    enabled = bool
    prefix  = string
    expiration = object({
      days = number
    })
  }))
  default = []
}
