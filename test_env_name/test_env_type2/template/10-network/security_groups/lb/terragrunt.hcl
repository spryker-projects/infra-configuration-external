include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  network = read_terragrunt_config(find_in_parent_folders("config/network/sg.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/vpc_security_group?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

inputs = {
  project_name = local.spryker.locals.project_name
  sg_name      = local.network.locals.lb.name
  vpc_id       = dependency.vpc_network.outputs.vpc_id
  sg_rules     = local.network.locals.lb.sg_rules
}
