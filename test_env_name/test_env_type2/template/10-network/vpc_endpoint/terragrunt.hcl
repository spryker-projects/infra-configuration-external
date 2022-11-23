include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  network = read_terragrunt_config(find_in_parent_folders("config/network/vpc.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/vpc_endpoint?ref=development"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "security_groups" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

inputs = {
  project_name              = local.spryker.locals.project_name
  region                    = local.spryker.locals.region
  vpc_id                    = dependency.vpc_network.outputs.vpc_id
  subnet_ids                = dependency.vpc_network.outputs.public_subnet_ids
  enable_vpc_endpoint_apigw = local.network.locals.enable_vpc_endpoint_apigw
  enable_vpc_endpoint_s3    = local.network.locals.enable_vpc_endpoint_s3
  vpc_security_group_ids    = [dependency.security_groups.outputs.security_group]
}
