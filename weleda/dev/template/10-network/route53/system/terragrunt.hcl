include {
  path = find_in_parent_folders()
}

generate "provider" {
  path              = "frontend.json"
  if_exists         = "overwrite"
  contents          = file("../../../frontend.json")
  disable_signature = true
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/route53_records?ref=v7.0.0"
}

dependency "alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

dependency "nlb" {
  config_path = find_in_parent_folders("10-network/lb/internal_nlb")
}

dependency "bastion" {
  config_path = find_in_parent_folders("10-network/ec2/bastion")
}

dependency "zone" {
  config_path = find_in_parent_folders("00-initial-infra/route53/zone")
}

inputs = {
  route53_zone_domain        = dependency.zone.outputs.zone_name
  internal_balancer_dns_name = dependency.nlb.outputs.dns_name
  internal_balancer_zone_id  = dependency.nlb.outputs.zone_id
  bastion_public_ip          = dependency.bastion.outputs.bastion_public_ip
  external_balancer_fqdn     = dependency.alb.outputs.alb_fqdn
  external_balancer_zone_id  = dependency.alb.outputs.alb_zone_id
  scheduler_fqdn_ec2         = local.spryker.locals.scheduler_fqdn
}
