locals {
  enabled = true
  s3_buckets = {
    bucket_type            = "private"
    versioning_enabled     = true
    lifecycle_old_versions = -1
    bucket_user_name       = null
  }
}
