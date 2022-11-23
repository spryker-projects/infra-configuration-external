locals {
  spryker        = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  environment    = split("-", local.spryker.locals.project_name)[1]
  ansible        = "${get_parent_terragrunt_dir()}/../../../ansible/${local.environment}"
  schedule       = "cron(15 1 ? * TUE *)"
  apply_rollback = false
}
