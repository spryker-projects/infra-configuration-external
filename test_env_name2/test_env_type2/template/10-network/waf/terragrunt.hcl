include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  waf     = read_terragrunt_config(find_in_parent_folders("config/network/waf.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/waf?ref=v7.0.0"
}

dependency "external_alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

skip = !local.waf.locals.waf_enabled

inputs = {
  project_name     = local.spryker.locals.project_name
  frontend_elb_arn = dependency.external_alb.outputs.alb_arn
}
