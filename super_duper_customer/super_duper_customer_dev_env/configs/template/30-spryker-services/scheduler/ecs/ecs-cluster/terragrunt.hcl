include {
  path = find_in_parent_folders()
}

locals {
  spryker     = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  ecs_cluster = read_terragrunt_config(find_in_parent_folders("config/spryker-services/ecs_cluster-scheduler.hcl"))
}

skip = local.spryker.locals.scheduler_type != "ecs"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_ecs_cluster?ref=v7.0.0"
}

dependency "iam_ec2" {
  config_path = find_in_parent_folders("00-initial-infra/iam/ec2-ecs-cluster")
}

dependency "ssh_keys" {
  config_path = find_in_parent_folders("00-initial-infra/ssh-keys")
}

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

inputs = {
  cluster_name                = local.ecs_cluster.locals.ecs_cluster_name
  ec2_instance_type           = local.ecs_cluster.locals.ec2_instance_type
  ec2_iam_instance_profile    = dependency.iam_ec2.outputs.ecs_iam_instance_profile
  ec2_volume_type             = local.ecs_cluster.locals.ec2_volume_type
  ec2_volume_size             = local.ecs_cluster.locals.ec2_volume_size
  autoscaling_min_size        = local.ecs_cluster.locals.autoscaling_min_size
  autoscaling_max_size        = local.ecs_cluster.locals.autoscaling_max_size
  autoscaling_target_capacity = local.ecs_cluster.locals.autoscaling_target_capacity
  ssh_key_name                = dependency.ssh_keys.outputs.ec2_key_name
  security_groups             = [dependency.security_group.outputs.security_group]
  vpc_id                      = dependency.vpc.outputs.vpc_id
  private_subnet_ids          = dependency.vpc.outputs.private_cmz_subnet_ids
}
