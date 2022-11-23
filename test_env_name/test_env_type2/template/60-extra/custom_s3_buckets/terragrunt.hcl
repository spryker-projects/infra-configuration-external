include {
  path = find_in_parent_folders()
}

locals {
  bucket_list = read_terragrunt_config(find_in_parent_folders("config/extras/custom_s3_buckets.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/s3/generic?ref=development"
}


inputs = {
  s3_buckets   = local.bucket_list.locals.s3_buckets
}
