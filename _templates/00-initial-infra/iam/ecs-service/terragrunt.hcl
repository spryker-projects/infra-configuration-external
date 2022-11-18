include {
  path = find_in_parent_folders()
}

locals {
  spryker  = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  newrelic = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/ecs_service?ref=v7.0.0"
}

inputs = {
  project_name     = local.spryker.locals.project_name
  spryker_services = local.newrelic.locals.newrelic_integration.enable_production_mode ? concat(local.spryker.locals.spryker_ecs_services, local.spryker.locals.monitoring_services) : local.spryker.locals.spryker_ecs_services
}
