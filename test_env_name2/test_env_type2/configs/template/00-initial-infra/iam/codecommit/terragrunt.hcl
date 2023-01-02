include {
  path = find_in_parent_folders()
}

locals {
  spryker  = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  repoconf = read_terragrunt_config(find_in_parent_folders("config/deployment/repoconf.hcl"))
}

skip = local.repoconf.locals.spryker_repo_conf.type != "codecommit"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/iam/codecommit?ref=v7.0.0"
}

dependency "codecommit" {
  config_path = find_in_parent_folders("40-deployment/codecommit")
  mock_outputs = { # Without mock_output we have errors if skip = true
    repo_arn = "dummy_arn"
  }
}

inputs = {
  project_name             = local.spryker.locals.project_name
  repository_name          = local.repoconf.locals.spryker_repo_conf.repo
  repository_arn           = dependency.codecommit.outputs.repo_arn
  generate_ssh_credentials = local.repoconf.locals.spryker_repo_conf.type == "codecommit" ? local.repoconf.locals.spryker_repo_conf.generate_ssh_credentials : false
  mirror_exist             = local.repoconf.locals.spryker_repo_conf.type == "codecommit" ? local.repoconf.locals.spryker_repo_conf.mirror_exist : false
}
