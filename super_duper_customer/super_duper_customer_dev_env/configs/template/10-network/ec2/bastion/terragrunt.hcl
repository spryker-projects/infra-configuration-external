include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  network = read_terragrunt_config(find_in_parent_folders("config/network/bastion.hcl"))
  secrets = read_terragrunt_config(find_in_parent_folders("/config/common/secrets.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/ec2/bastion?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

dependency "iam_role" {
  config_path = find_in_parent_folders("00-initial-infra/iam/ec2-bastion")
}

dependency "ssh_keys" {
  config_path = find_in_parent_folders("00-initial-infra/ssh-keys")
}

dependency "efs" {
  config_path = find_in_parent_folders("10-network/efs")
}

inputs = {
  project_name             = local.spryker.locals.project_name
  instance_name            = local.network.locals.instance_name
  hashicorp_vault_password = local.secrets.locals.hashicorp_vault_password
  EASYRSA_CERT_EXPIRE      = local.secrets.locals.EASYRSA_CERT_EXPIRE
  vpn_inactivity_timeout   = local.secrets.locals.vpn_inactivity_timeout
  settings = {
    size                       = local.network.locals.settings.size
    ebs_size                   = local.network.locals.settings.ebs_size
    ebs_iops                   = local.network.locals.settings.ebs_iops
    ebs_type                   = local.network.locals.settings.ebs_type
    ebs_block_device_encrypted = local.network.locals.settings.ebs_block_device_encrypted
    security_group             = dependency.vpc_security_group.outputs.security_group
    subnet_id                  = dependency.vpc_network.outputs.public_subnet_ids.0
  }
  iam_instance_profile = dependency.iam_role.outputs.ecs_iam_instance_profile
  vpc_cidr_block       = dependency.vpc_network.outputs.vpc_cidr_block
  vpn_cidr             = local.network.locals.vpn_cidr
  sftp_enable          = local.network.locals.sftp_enable
  custom_sftp_user = {
    name = local.network.locals.custom_sftp_user.name
    path = local.network.locals.custom_sftp_user.path
  }
  ec2_key_name = dependency.ssh_keys.outputs.ec2_key_name
  efs_id       = dependency.efs.outputs.efs_file_system_id
}
