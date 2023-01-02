include {
  path = find_in_parent_folders()
}

locals {
  spryker_service = read_terragrunt_config(find_in_parent_folders("config/spryker-services/ecs_service-gluebackend.hcl"))
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  ecs_cluster     = read_terragrunt_config(find_in_parent_folders("config/spryker-services/ecs_cluster-primary.hcl"))
}

skip = !contains(local.spryker.locals.spryker_services, local.spryker_service.locals.service_name)

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_ecs_service?ref=v7.0.0"
}

dependency "iam_ecs_service" {
  config_path = find_in_parent_folders("00-initial-infra/iam/ecs-service")
}

dependency "cert" {
  config_path = find_in_parent_folders("00-initial-infra/acm/main")
}

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/initial")
}

dependency "external_alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

dependency "internal_nlb" {
  config_path = find_in_parent_folders("10-network/lb/internal_nlb")
}

dependency "ecr" {
  config_path = find_in_parent_folders("20-aws-based-infra/ecr")
}

dependency "spryker_variables" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-variables")
}

dependency "spryker_secrets" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/custom-secrets")
}

dependency "ecs_cluster" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-cluster/ecs-cluster")
}

inputs = {
  cluster_name                       = local.ecs_cluster.locals.ecs_cluster_name
  service_name                       = local.spryker_service.locals.service_name
  cluster_id                         = dependency.ecs_cluster.outputs.ecs_cluster_id
  network_mode                       = local.spryker_service.locals.network_mode
  cpu_limit                          = local.spryker_service.locals.cpu_limit
  memory_limit                       = local.spryker_service.locals.memory_limit
  execution_role_arn                 = contains(local.spryker.locals.spryker_ecs_services, local.spryker_service.locals.service_name) == true ? dependency.iam_ecs_service.outputs.aws_iam_role_arn[local.spryker_service.locals.service_name] : "dummy_role"
  discovery_namespace_id             = dependency.ecs_cluster.outputs.discovery_namespace_id
  vpc_id                             = dependency.vpc.outputs.vpc_id
  subnets                            = dependency.vpc.outputs.private_middle_subnet_ids
  security_groups                    = [dependency.security_group.outputs.security_group]
  volumes                            = local.spryker_service.locals.volumes
  scheduling_strategy                = local.spryker_service.locals.scheduling_strategy
  desired_count                      = local.spryker_service.locals.desired_count
  health_check_grace_period_seconds  = local.spryker_service.locals.health_check_grace_period_seconds
  deployment_maximum_percent         = local.spryker_service.locals.deployment_maximum_percent
  deployment_minimum_healthy_percent = local.spryker_service.locals.deployment_minimum_healthy_percent
  autoscaling_enabled                = local.spryker_service.locals.autoscaling_enabled
  autoscaling_min_capacity           = local.spryker_service.locals.autoscaling_min_capacity
  autoscaling_max_capacity           = local.spryker_service.locals.autoscaling_max_capacity
  capacity_provider                  = dependency.ecs_cluster.outputs.capacity_provider_name
  load_balancer_arn                  = local.spryker_service.locals.load_balancer_type == "internal" ? dependency.internal_nlb.outputs.arn : dependency.external_alb.outputs.alb_arn
  listener_mappings                  = local.spryker_service.locals.listener_mappings
  primary_cert_arn                   = dependency.cert.outputs.cert_arn
  secondary_cert_arns                = []
  deregistration_delay               = local.spryker_service.locals.deregistration_delay
  logs_expire                        = local.spryker_service.locals.logs_expire
  container_definitions = {
    name             = local.spryker_service.locals.container_definition.name
    image            = contains(local.spryker.locals.spryker_ecs_services, local.spryker_service.locals.service_name) == true ? (local.spryker_service.locals.container_definition.image == null ? "${dependency.ecr.outputs.repository_urls[local.spryker_service.locals.service_name]}:latest" : local.spryker_service.locals.container_definition.image) : null
    mountPoints      = local.spryker_service.locals.container_definition.mountPoints
    portMappings     = local.spryker_service.locals.container_definition.portMappings
    environmentFiles = contains(local.spryker.locals.spryker_ecs_services, local.spryker_service.locals.service_name) == true ? [{ "value" = dependency.spryker_variables.outputs.environment_files[local.spryker_service.locals.service_name], "type" = "s3" }] : null
    secrets          = [for k, v in dependency.spryker_secrets.outputs.ssm_parameter_address : { "name" = k, "valueFrom" = v.arn }]
  }
}
