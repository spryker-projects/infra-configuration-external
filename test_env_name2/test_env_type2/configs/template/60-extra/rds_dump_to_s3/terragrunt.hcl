include {
  path = find_in_parent_folders()
}

locals {
  spryker   = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  s3_config = read_terragrunt_config(find_in_parent_folders("config/extras/rds_dump_to_s3.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/s3/generic?ref=development"
}

dependency "iam_customer" {
  config_path = find_in_parent_folders("00-initial-infra/iam/customer")
}

skip = !local.s3_config.locals.enabled

inputs = {
  s3_buckets = [
    {
      bucket_name            = "${local.spryker.locals.project_name}-db-dump"
      customer_group_name    = dependency.iam_customer.outputs.customer_group_name
      bucket_type            = local.s3_config.locals.s3_buckets.bucket_type
      versioning_enabled     = local.s3_config.locals.s3_buckets.versioning_enabled
      lifecycle_old_versions = local.s3_config.locals.s3_buckets.lifecycle_old_versions
      bucket_user_name       = local.s3_config.locals.s3_buckets.bucket_user_name
    }
  ]
}
