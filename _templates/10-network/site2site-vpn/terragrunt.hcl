include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  site2site_vpn_config = read_terragrunt_config(find_in_parent_folders("config/extras/site2site_vpn.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/site2site_vpn?ref=development"
}

skip = !local.site2site_vpn_config.locals.enabled

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

inputs = {
  project_name                           = local.spryker.locals.project_name
  vpc_id                                 = dependency.vpc_network.outputs.vpc_id
  subnet_ids                             = dependency.vpc_network.outputs.private_cmz_subnet_ids
  device_name                            = local.site2site_vpn_config.locals.device_name
  description                            = local.site2site_vpn_config.locals.description
  site2site_customer_gateway_ip_address  = local.site2site_vpn_config.locals.site2site_customer_gateway_ip_address
  site2site_customer_gateway_bgp_asn     = local.site2site_vpn_config.locals.site2site_customer_gateway_bgp_asn
  site2site_routes                       = local.site2site_vpn_config.locals.site2site_routes []
  site2site_static_routs_only            = local.site2site_vpn_config.locals.site2site_static_routs_only
  tunnel_ike_versions                    = local.site2site_vpn_config.locals.tunnel_ike_versions
  tunnel_phase_dh_group_numbers          = local.site2site_vpn_config.locals.tunnel_phase_dh_group_numbers
  tunnel_phase_encryption_algorithms     = local.site2site_vpn_config.locals.tunnel_phase_encryption_algorithms
  tunnel_phase_integrity_algorithms      = local.site2site_vpn_config.locals.tunnel_phase_integrity_algorithms
  tunnel_rekey_margin_time_seconds       = local.site2site_vpn_config.locals.tunnel_rekey_margin_time_seconds
  tunnel_phase_lifetime_seconds          = local.site2site_vpn_config.locals.tunnel_phase_lifetime_seconds
  tunnel_startup_action                  = local.site2site_vpn_config.locals.tunnel_startup_action
}

