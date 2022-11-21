include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/acm?ref=v7.0.0"
}

dependency "route53_zone" {
  config_path = find_in_parent_folders("00-initial-infra/route53/zone")
}

inputs = {
  zone_name         = dependency.route53_zone.outputs.zone_name
  alternative_names = [for domain, v in jsondecode(templatefile(find_in_parent_folders("frontend.json"), {})) : domain]
}
