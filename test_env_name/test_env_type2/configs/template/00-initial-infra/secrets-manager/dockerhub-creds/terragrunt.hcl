include {
  path = find_in_parent_folders()
}

locals {
  spryker    = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  deployment = read_terragrunt_config(find_in_parent_folders("config/deployment/codebuild.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/spryker_secrets_manager?ref=v7.0.0"
}

inputs = {
  project_name = local.spryker.locals.project_name
  secret_name  = local.deployment.locals.secret_name
  secret_contents = {
    username = "${local.deployment.locals.dockerhub_username}"
    password = "${local.deployment.locals.dockerhub_password}"
  }
}
