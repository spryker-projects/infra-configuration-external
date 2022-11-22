include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/route53_zone?ref=v7.0.0"
}

inputs = {
  zone_name = element(distinct([for domain in jsondecode(templatefile(find_in_parent_folders("frontend.json"), {})) : domain.zone]), 0)
}
