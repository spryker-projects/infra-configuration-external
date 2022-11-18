locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  alb = {
    balancer_name = "${local.spryker.locals.project_name}"
    is_protected  = false
  }
  nlb = {
    internal                      = true
    balancer_name                 = "${local.spryker.locals.project_name}-main"
    enable_vpc_endpoint_service   = false
    vpc_endpoint_allowed_accounts = []
  }
}
