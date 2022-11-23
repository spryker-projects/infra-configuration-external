include {
  path = find_in_parent_folders()
}

locals {
  spryker  = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  codepipeline_notifications = read_terragrunt_config(find_in_parent_folders("config/deployment/codepipeline-notifications.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/codepipeline_notifications?ref=v7.0.0"
}

dependency "lambda" {
  config_path = find_in_parent_folders("20-aws-based-infra/lambda/pipeline-nr-notifier")
}

dependency "codepiplines-destructive" {
  config_path = find_in_parent_folders("40-deployment/codepipelines/destructive")
}

dependency "codepiplines-normal" {
  config_path = find_in_parent_folders("40-deployment/codepipelines/normal")
}

dependency "codepiplines-build" {
  config_path = find_in_parent_folders("40-deployment/codepipelines/build")
}

dependency "codepiplines-scheduler-rollout" {
  config_path = find_in_parent_folders("40-deployment/codepipelines/scheduler-rollout")
}

inputs = {
  project_name = local.spryker.locals.project_name
  pipeline_arns = [
    dependency.codepiplines-destructive.outputs.codepipeline_arn,
    dependency.codepiplines-normal.outputs.codepipeline_arn,
    dependency.codepiplines-build.outputs.codepipeline_arn,
    dependency.codepiplines-scheduler-rollout.outputs.codepipeline_arn
  ]
  opsgenie_api_key                          = local.codepipeline_notifications.locals.opsgenie_api_key
  newrelic_lambda_notificator_arn           = dependency.lambda.outputs.newrelic_lambda_notificator_arn
  newrelic_lambda_notificator_function_name = dependency.lambda.outputs.newrelic_lambda_notificator_function_name
}
