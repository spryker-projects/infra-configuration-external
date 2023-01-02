locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  enabled = false
  s3_buckets = [
    {
      bucket_name            = "${local.spryker.locals.project_name}-bucket-private"
      bucket_type            = "private"
      versioning_enabled     = false
      lifecycle_old_versions = -1
      bucket_user_name       = null
      customer_group_name    = null
    }
  ]
}

