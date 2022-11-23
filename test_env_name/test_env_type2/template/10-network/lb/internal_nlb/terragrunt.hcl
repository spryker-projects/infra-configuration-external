include {
  path = find_in_parent_folders()
}

locals {
  network = read_terragrunt_config(find_in_parent_folders("config/network/lb.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/nlb?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

inputs = {
  name                          = local.network.locals.nlb.balancer_name
  enable_vpc_endpoint_service   = local.network.locals.nlb.enable_vpc_endpoint_service
  internal                      = local.network.locals.nlb.internal
  subnets                       = dependency.vpc_network.outputs.private_dmz_subnet_ids
  vpc_endpoint_allowed_accounts = local.network.locals.nlb.vpc_endpoint_allowed_accounts
}
