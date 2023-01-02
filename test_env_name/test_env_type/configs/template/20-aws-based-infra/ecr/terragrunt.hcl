include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/ecr?ref=v7.0.0"
}

inputs = {
  project_name = local.spryker.locals.project_name
  service_list = local.spryker.locals.spryker_ecr_repos
}
