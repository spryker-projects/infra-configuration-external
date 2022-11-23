include {
  path = find_in_parent_folders()
}

locals {
  spryker          = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  route53_resolver = read_terragrunt_config(find_in_parent_folders("config/extras/route53_resolver.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/route53_resolver?ref=development"
}

skip = !local.route53_resolver.locals.enabled

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

inputs = {
  project_name       = local.spryker.locals.project_name
  security_group_ids = [dependency.vpc_security_group.outputs.security_group]
  ip_addresses       = [for v in dependency.vpc_network.outputs.private_dmz_subnet_ids : { subnet_id = v }]
  domain_name        = local.route53_resolver.locals.domain_name
  target_ips         = local.route53_resolver.locals.target_ips
  vpc_id             = dependency.vpc_network.outputs.vpc_id
}
