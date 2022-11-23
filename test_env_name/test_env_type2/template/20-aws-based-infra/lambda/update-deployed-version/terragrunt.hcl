include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  spryker-secrets = read_terragrunt_config(find_in_parent_folders("config/common/secrets.hcl"))
  newrelic        = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lambda/update_deployed_version?ref=v7.0.0"
}

dependency "iam" {
  config_path = find_in_parent_folders("00-initial-infra/iam/update-deployed-version")
}

inputs = {
  project_name = local.spryker.locals.project_name
  iam_role_arn = dependency.iam.outputs.iam_role_arn
}
