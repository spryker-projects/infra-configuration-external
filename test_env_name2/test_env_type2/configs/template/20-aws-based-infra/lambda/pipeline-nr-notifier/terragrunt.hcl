include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  spryker-secrets = read_terragrunt_config(find_in_parent_folders("config/common/secrets.hcl"))
  newrelic        = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lambda/newrelic_notificator?ref=v7.0.0"
}

dependency "lambda" {
  config_path = find_in_parent_folders("00-initial-infra/iam/lambda")
}

inputs = {
  project_name                   = local.spryker.locals.project_name
  newrelic_pipeline_iam_role_arn = dependency.lambda.outputs.lambda_iam_role_arn
  newrelic_account_id            = local.newrelic.locals.newrelic_integration.account_id
  newrelic_ingest_key            = local.newrelic.locals.newrelic_integration.insights_key
  newrelic_account_type          = local.newrelic.locals.newrelic_integration.newrelic_account_type
}
