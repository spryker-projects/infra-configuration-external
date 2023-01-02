include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/china?ref=v7.0.0"
}

dependency "iam_customer" {
  config_path = find_in_parent_folders("00-initial-infra/iam/customer")
}

inputs = {
  project_name        = local.spryker.locals.project_name
  customer_group_name = dependency.iam_customer.outputs.customer_group_name
}
