include {
  path = find_in_parent_folders()
}

locals {
  spryker       = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  s3_cdn_config = read_terragrunt_config(find_in_parent_folders("config/extras/s3_cdn.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/route53_s3_cdn?ref=development"
}

skip = !local.s3_cdn_config.locals.enabled

dependency "cloudfront" {
  config_path = find_in_parent_folders("00-initial-infra/cloudfront")
}

inputs = {
  cdn                          = local.s3_cdn_config.locals.s3_buckets
  route53_zone_domain          = local.spryker.locals.route53_zone_domain
  cloudfront_distribution_list = dependency.cloudfront.outputs.cloudfront_distribution_list
}
