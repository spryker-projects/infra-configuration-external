include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  spryker_service = read_terragrunt_config(find_in_parent_folders("config/spryker-services/target-groups.hcl"))
}

skip = local.spryker.locals.scheduler_type != "ec2"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lb_target_group_single?ref=v7.0.0"
}

dependency "vpc_network" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "ec2" {
  config_path = find_in_parent_folders("30-spryker-services/scheduler/ec2/instance")
  mock_outputs = {
    instance_id            = "dummy_instance_id"
  }
}

dependency "nlb" {
  config_path = find_in_parent_folders("10-network/lb/internal_nlb")
}

dependency "alb" {
  config_path = find_in_parent_folders("10-network/lb/external_alb")
}

inputs = {
  target_group_name                   = "${local.spryker.locals.project_name}-scheduler"
  target_port                         = local.spryker_service.locals.target_port
  target_protocol                     = local.spryker_service.locals.target_protocol
  target_type                         = local.spryker_service.locals.target_type
  vpc_id                              = dependency.vpc_network.outputs.vpc_id
  deregistration_delay                = local.spryker_service.locals.deregistration_delay
  scheduler_healthcheck_configuration = local.spryker_service.locals.scheduler_healthcheck_configuration
  target_instance_id                  = dependency.ec2.outputs.instance_id
  load_balancer_arn                   = dependency.nlb.outputs.arn
  lb_port                             = local.spryker_service.locals.lb_port
  lb_protocol                         = local.spryker_service.locals.lb_protocol
  target_hosts                        = [local.spryker.locals.scheduler_fqdn]
  stickiness_enabled                  = local.spryker_service.locals.stickiness_enabled
  health_check_enabled                = local.spryker_service.locals.health_check_enabled
  is_alb                              = local.spryker_service.locals.is_alb
  is_scheduler                        = local.spryker_service.locals.is_scheduler
  listener_rule_lb_arn                = dependency.alb.outputs.alb_arn
  listener_rule_priority              = local.spryker_service.locals.listener_rule_priority
}
