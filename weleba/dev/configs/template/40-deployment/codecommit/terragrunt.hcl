include {
  path = find_in_parent_folders()
}

locals {
  spryker  = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  repoconf = read_terragrunt_config(find_in_parent_folders("config/deployment/repoconf.hcl"))
}

skip = local.repoconf.locals.spryker_repo_conf.type != "codecommit"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_codecommit?ref=v7.0.0"
}

inputs = {
  repository_name = local.repoconf.locals.spryker_repo_conf.repo
  description     = local.repoconf.locals.spryker_repo_conf.description
  mirror_exist    = local.repoconf.locals.spryker_repo_conf.type == "codecommit" ? local.repoconf.locals.spryker_repo_conf.mirror_exist : false
}
