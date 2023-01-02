include {
  path = find_in_parent_folders()
}

locals {
  spryker  = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  newrelic = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/newrelic?ref=v7.0.0"
}

skip = !local.newrelic.locals.newrelic_integration.enable_production_mode

dependency "aws_data" {
  config_path = find_in_parent_folders("00-initial-infra/aws-data")
}

dependency "s3_conf_d" {
  config_path = find_in_parent_folders("00-initial-infra/s3/conf.d")
}

dependency "alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

dependency "ecs_service_frontend" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-cluster/services/frontend")
}

dependency "ecs_service_rabbitmq" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-cluster/services/rabbitmq")
}

inputs = {
  project_name                    = local.spryker.locals.project_name
  project_owner                   = local.spryker.locals.project_owner
  env_type                        = local.spryker.locals.env_type
  aws_integration                 = local.newrelic.locals.aws_integration
  customer_aws_account_id         = dependency.aws_data.outputs.account_id
  load_balancer_arn               = dependency.alb.outputs.alb_arn
  alb_target_group_id             = dependency.ecs_service_frontend.outputs.target_group_ids["https"]
  synthetics_yves_urls            = local.newrelic.locals.synthetics_yves_urls
  synthetics_healthcheck_settings = local.newrelic.locals.synthetics_healthcheck_settings
  opsgenie_teams                  = local.newrelic.locals.opsgenie_teams
  rabbit_mq_ecs_service_name      = dependency.ecs_service_rabbitmq.outputs.ecs_service_name
  confd_s3_bucket_name            = dependency.s3_conf_d.outputs.confd_s3_bucket_name
  newrelic_integration            = local.newrelic.locals.newrelic_integration
  alerting_settings               = local.newrelic.locals.alerting_settings
  basic_auth                      = local.newrelic.locals.basic_auth
}
