include {
  path = find_in_parent_folders()
}

locals {
  spryker          = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  spryker-services = read_terragrunt_config(find_in_parent_folders("config/spryker-services/spryker-environment.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/spryker_secrets_ssm?ref=v7.0.0"
}

inputs = {
  project_name    = local.spryker.locals.project_name
  ssm_prefix      = local.spryker-services.locals.codebuild.ssm_prefix
  parameters_type = local.spryker-services.locals.codebuild.parameters_type
  spryker_secrets = local.spryker-services.locals.codebuild.spryker_secrets
}
