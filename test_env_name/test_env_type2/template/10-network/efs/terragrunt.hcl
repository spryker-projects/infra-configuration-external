include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  network = read_terragrunt_config(find_in_parent_folders("config/network/bastion.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/efs?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/efs")
}

inputs = {
  project_name                            = local.spryker.locals.project_name
  efs_infrequent_access_transition_policy = local.network.locals.efs_infrequent_access_transition_policy
  sftp_enable                             = local.network.locals.sftp_enable
  private_subnet_ids                      = dependency.vpc_network.outputs.private_cmz_subnet_ids
  efs_sg                                  = dependency.vpc_security_group.outputs.security_group
}
