include {
  path = find_in_parent_folders()
}

locals {
  spryker          = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  newrelic         = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
  spryker-services = read_terragrunt_config(find_in_parent_folders("config/spryker-services/ec2_scheduler.hcl"))
}

skip = local.spryker.locals.scheduler_type != "ec2"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/ec2/scheduler?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

dependency "iam_role" {
  config_path = find_in_parent_folders("00-initial-infra/iam/ec2-scheduler")
}

dependency "ssh_keys" {
  config_path = find_in_parent_folders("00-initial-infra/ssh-keys")
}

dependency "efs" {
  config_path = find_in_parent_folders("10-network/efs")
}

dependency "nlb" {
  config_path = find_in_parent_folders("10-network/lb/internal_nlb")
}

inputs = {
  project_name  = local.spryker.locals.project_name
  instance_name = local.spryker-services.locals.instance_name
  settings = {
    size                        = local.spryker-services.locals.settings.size
    ebs_size                    = local.spryker-services.locals.settings.ebs_size
    ebs_iops                    = local.spryker-services.locals.settings.ebs_iops
    ebs_type                    = local.spryker-services.locals.settings.ebs_type
    ebs_block_device_encrypted  = local.spryker-services.locals.settings.ebs_block_device_encrypted
    root_block_type             = local.spryker-services.locals.settings.root_block_type
    root_block_size             = local.spryker-services.locals.settings.root_block_size
    root_block_device_encrypted = local.spryker-services.locals.settings.root_block_device_encrypted
    security_group              = dependency.vpc_security_group.outputs.security_group
    subnet_id                   = dependency.vpc_network.outputs.private_cmz_subnet_ids.0
  }
  iam_instance_profile   = dependency.iam_role.outputs.ecs_iam_instance_profile_scheduler
  sftp_enable            = local.spryker-services.locals.sftp_enable
  ec2_key_name           = dependency.ssh_keys.outputs.ec2_key_name
  efs_id                 = dependency.efs.outputs.efs_file_system_id
  sftp_efs_mount_point   = local.spryker-services.locals.sftp_efs_mount_point
  newrelic_agent_version = local.newrelic.locals.newrelic_agent_version
  newrelic_license_key   = local.newrelic.locals.newrelic_integration.license_key
  vpc_id                 = dependency.vpc_network.outputs.vpc_id
}
