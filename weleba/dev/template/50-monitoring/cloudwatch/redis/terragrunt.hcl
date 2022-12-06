include {
  path = find_in_parent_folders()
}

locals {
  spryker    = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  cloudwatch = read_terragrunt_config(find_in_parent_folders("config/monitoring/cloudwatch.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/cloudwatch/redis?ref=v7.0.0"
}

dependency "elasticache" {
  config_path = find_in_parent_folders("20-aws-based-infra/elasticache")
}

inputs = {
  project_name    = local.spryker.locals.project_name
  widget_width    = local.cloudwatch.locals.redis.widget_width
  widget_height   = local.cloudwatch.locals.redis.widget_height
  widget_title    = local.cloudwatch.locals.redis.widget_title
  member_clusters = dependency.elasticache.outputs.member_clusters
}
