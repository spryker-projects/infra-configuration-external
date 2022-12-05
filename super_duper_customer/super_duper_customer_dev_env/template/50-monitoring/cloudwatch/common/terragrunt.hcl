include {
  path = find_in_parent_folders()
}

locals {
  spryker                      = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  cloudwatch                   = read_terragrunt_config(find_in_parent_folders("config/monitoring/cloudwatch.hcl"))
  newrelic_host_agent          = read_terragrunt_config(find_in_parent_folders("config/monitoring/ecs_service-newrelic-host-agent.hcl"))
  newrelic_rabbitmq_monitoring = read_terragrunt_config(find_in_parent_folders("config/monitoring/ecs_service-newrelic-rabbitmq-monitoring.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/cloudwatch/common?ref=v7.0.0"
}

dependency "external_alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

dependency "es" {
  config_path = find_in_parent_folders("20-aws-based-infra/es")
}

dependency "rds" {
  config_path = find_in_parent_folders("20-aws-based-infra/rds")
}

inputs = {
  project_name            = local.spryker.locals.project_name
  db_instance_identifier  = dependency.rds.outputs.db_identifier
  default_widget_sizes    = local.cloudwatch.locals.common.default_widget_sizes
  ecs_services            = [for service in local.spryker.locals.spryker_services : service if service != local.newrelic_host_agent.locals.service_name && service != local.newrelic_rabbitmq_monitoring.locals.service_name]
  es_domainname           = dependency.es.outputs.domain_name
  frontend_elb_arn_suffix = dependency.external_alb.outputs.alb_arn_suffix
  http_responses          = local.cloudwatch.locals.common.http_responses
  widget_height           = local.cloudwatch.locals.common.widget_height
  widget_title            = local.cloudwatch.locals.common.widget_title
  widget_width            = local.cloudwatch.locals.common.widget_width
}
