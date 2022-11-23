include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  network = read_terragrunt_config(find_in_parent_folders("config/network/vpc.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/vpc_networking?ref=v7.0.0"
}

inputs = {
  project_name              = local.spryker.locals.project_name
  vpc_cidr_block            = local.network.locals.vpc_cidr_block
  vpc_enable_ipv6           = local.network.locals.vpc_enable_ipv6
  secondary_cidr            = local.network.locals.secondary_cidr
  public_nets               = local.network.locals.public_nets
  private_cmz_subnets       = local.network.locals.private_cmz_subnets
  private_middle_subnets    = local.network.locals.private_middle_subnets
  private_dmz_subnets       = local.network.locals.private_dmz_subnets
  enable_vpc_peering_to_vpn = local.network.locals.enable_vpc_peering_to_vpn
  nat_redundancy            = local.network.locals.nat_redundancy
}
