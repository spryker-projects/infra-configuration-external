locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  ssm_paths_env_vars = {
    common = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/common/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/common/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/common/public"
    ]
    app = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/app/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/app/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/app/public"
    ]
    scheduler = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/scheduler/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/scheduler/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/scheduler/public"
    ]
    pipeline = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/pipeline/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/pipeline/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/config/pipeline/public"
    ]
  }
  ssm_paths_secrets = {
    common = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/common/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/common/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/common/public"
    ]
    app = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/app/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/app/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/app/public"
    ]
    scheduler = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/scheduler/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/scheduler/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/scheduler/public"
    ]
    pipeline = [
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/pipeline/internal",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/pipeline/limited",
      "/${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/secret/pipeline/public"
    ]
  }
}
