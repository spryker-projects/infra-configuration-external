include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/ec2/scheduler?ref=v7.0.0"
}

dependency "ssm" {
  config_path = find_in_parent_folders("00-initial-infra/ssm")
}

inputs = {
  project_name             = local.spryker.locals.project_name
  ssm_ansible_password_arn = dependency.ssm.outputs.ssm_parameter_address.ssm_ansible_password.arn
}
