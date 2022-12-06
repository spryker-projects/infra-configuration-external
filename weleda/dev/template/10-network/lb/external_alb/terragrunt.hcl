include {
  path = find_in_parent_folders()
}

locals {
  network = read_terragrunt_config(find_in_parent_folders("config/network/lb.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/alb?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/lb")
}

inputs = {
  balancer_name  = local.network.locals.alb.balancer_name
  public_nets    = dependency.vpc_network.outputs.public_subnet_ids
  security_group = dependency.vpc_security_group.outputs.security_group
  vpc_id         = dependency.vpc_network.outputs.vpc_id
  is_protected   = local.network.locals.alb.is_protected
}
