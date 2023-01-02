include {
  path = find_in_parent_folders()
}

locals {
  spryker       = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  s3_cdn_config = read_terragrunt_config(find_in_parent_folders("config/extras/s3_cdn.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/s3/cdn?ref=development"
}

skip = !local.s3_cdn_config.locals.enabled

inputs = {
  cdn = local.s3_cdn_config.locals.s3_buckets
}
