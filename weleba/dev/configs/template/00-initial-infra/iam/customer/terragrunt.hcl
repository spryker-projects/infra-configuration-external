include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  iam     = read_terragrunt_config(find_in_parent_folders("config/initial-infra/iam.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/customer?ref=v7.0.0"
}

dependency "ssm" {
  config_path = find_in_parent_folders("00-initial-infra/ssm")
}

inputs = {
  attach_policy_arns       = local.iam.locals.customer.additional_policy_arns
  project_name             = local.spryker.locals.project_name
  ssm_ansible_password_arn = dependency.ssm.outputs.ssm_parameter_address.ssm_ansible_password.arn
}
