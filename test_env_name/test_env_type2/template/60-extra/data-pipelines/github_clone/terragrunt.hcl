include {
  path = find_in_parent_folders()
}

locals {
  gmv_cc_shared        = read_terragrunt_config(find_in_parent_folders("config/extras/gmv_and_composer_shared.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/github_clone?ref=v7.0.0"
}

skip = !local.gmv_cc_shared.locals.gmv_enabled

inputs = {
  token        = local.gmv_cc_shared.locals.gmv_and_composer_content_github_token
  repo_address = local.gmv_cc_shared.locals.gmv_and_composer_content_repo
}
