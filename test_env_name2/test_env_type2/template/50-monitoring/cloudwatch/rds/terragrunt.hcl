include {
  path = find_in_parent_folders()
}

locals {
  spryker    = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  cloudwatch = read_terragrunt_config(find_in_parent_folders("config/monitoring/cloudwatch.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/cloudwatch/rds?ref=v7.0.0"
}

dependency "rds" {
  config_path = find_in_parent_folders("20-aws-based-infra/rds")
}

inputs = {
  project_name  = local.spryker.locals.project_name
  db_identifier = dependency.rds.outputs.db_identifier
  widget_width  = local.cloudwatch.locals.rds.widget_width
  widget_height = local.cloudwatch.locals.rds.widget_height
  widget_title  = local.cloudwatch.locals.rds.widget_title
}
