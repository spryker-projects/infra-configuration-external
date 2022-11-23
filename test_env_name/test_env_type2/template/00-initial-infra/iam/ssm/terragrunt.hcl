include {
  path = find_in_parent_folders()
}

locals {
  spryker       = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  initial-infra = read_terragrunt_config(find_in_parent_folders("config/initial-infra/iam.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/ssm?ref=v7.0.0"
}

inputs = {
  project_name   = local.spryker.locals.project_name
  apply_rollback = local.initial-infra.locals.ssm.apply_rollback
}
