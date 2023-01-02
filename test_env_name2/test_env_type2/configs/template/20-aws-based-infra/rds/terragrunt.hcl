include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  aws-based-infra = read_terragrunt_config(find_in_parent_folders("config/aws-based-infra/rds.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/rds_mariadb?ref=v7.0.0"
}

dependency "kms_key" {
  config_path = find_in_parent_folders("00-initial-infra/kms/rds")
}

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "sg" {
  config_path = find_in_parent_folders("10-network/security_groups/rds")
}

inputs = {
  project_name         = local.spryker.locals.project_name
  kms_key_arn          = dependency.kms_key.outputs.kms_key_arn
  subnets              = dependency.vpc.outputs.private_cmz_subnet_ids
  db_security_group_id = dependency.sg.outputs.security_group
  settings             = local.aws-based-infra.locals.settings
}
