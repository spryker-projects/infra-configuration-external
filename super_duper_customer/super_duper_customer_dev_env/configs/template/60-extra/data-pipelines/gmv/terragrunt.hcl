include {
  path = find_in_parent_folders()
}

dependency "data_source" {
  config_path = find_in_parent_folders("20-aws-based-infra/rds")
}

locals {
  spryker               = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  gmv                   = read_terragrunt_config(find_in_parent_folders("config/extras/gmv.hcl"))
  gmv_cc_shared         = read_terragrunt_config(find_in_parent_folders("config/extras/gmv_and_composer_shared.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lambda/gmv?ref=v7.0.0"
}

skip = !local.gmv_cc_shared.locals.gmv_enabled

dependency "gmv_secrets" {
  config_path = find_in_parent_folders("60-extra/data-pipelines/aws_secrets_manager")
  mock_outputs = {
    secret_arn       = "dummy_secret_arn"
  }
}

dependency "docker_build" {
  config_path = find_in_parent_folders("60-extra/data-pipelines/docker_build_gmv")
  mock_outputs = {
    docker_image_uri       = "dummy_docker_image_uri"
  }
}

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "vpc_security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/rds")
}

dependency "data_source" {
  config_path = find_in_parent_folders("20-aws-based-infra/rds")
}

dependency "aws_data" {
  config_path = find_in_parent_folders("00-initial-infra/aws-data")
}

inputs = {
  lambda_name                                      = "${local.spryker.locals.project_name}-gmv-data"
  forward_rule_schedule_expression                 = local.gmv.locals.forward_rule_schedule_expression
  lambda_secrets_region                            = local.spryker.locals.region
  lambda_security_group_ids                        = tolist([dependency.vpc_security_group.outputs.security_group])
  lambda_spryker_aws_account_email                 = local.gmv_cc_shared.locals.aws_environment_email
  lambda_spryker_aws_account_id                    = dependency.aws_data.outputs.account_id
  lambda_spryker_db_details_arn                    = dependency.gmv_secrets.outputs.secret_arn
  lambda_spryker_bucket_details_arn                = dependency.gmv_secrets.outputs.secret_arn
  lambda_spryker_enabled_features_endpoint         = local.gmv.locals.lambda_spryker_enabled_features_endpoint
  lambda_spryker_enabled_features_endpoint_api_key = local.gmv_cc_shared.locals.lambda_spryker_enabled_features_endpoint_api_key
  lambda_subnet_ids                                = dependency.vpc.outputs.private_cmz_subnet_ids
  docker_image_uri                                 = dependency.docker_build.outputs.docker_image_uri
  create_retro_rule                                = local.gmv.locals.create_retro_rule
  lambda_timeout                                   = local.gmv.locals.lambda_timeout
  project_name                                     = local.spryker.locals.project_name
}
