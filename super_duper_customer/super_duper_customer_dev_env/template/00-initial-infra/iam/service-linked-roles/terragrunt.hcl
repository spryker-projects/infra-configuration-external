include {
  path = find_in_parent_folders()
}

locals {
  initial-infra = read_terragrunt_config(find_in_parent_folders("config/initial-infra/iam.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/service_linked_roles?ref=v7.0.0"
}

inputs = {
  enable_es_role          = local.initial-infra.locals.slr.enable_es_role
  enable_ssm_role         = local.initial-infra.locals.slr.enable_ssm_role
  elasticsearch_role_name = local.initial-infra.locals.slr.elasticsearch_role_name
}
