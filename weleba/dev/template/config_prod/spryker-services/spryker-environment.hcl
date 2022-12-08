locals {
  secrets = read_terragrunt_config(find_in_parent_folders("config/common/secrets.hcl"))
  custom-secrets = {
    ssm_prefix      = "custom-secrets/"
    parameters_type = "SecureString"
    spryker_secrets = local.secrets.locals.spryker_secrets
  }
  base-task-definition = {
    ssm_prefix      = "codebuild/base_task_definition/"
    parameters_type = "SecureString"
  }
  codebuild = {
    ssm_prefix      = ""
    parameters_type = "String"
    spryker_secrets = {
      desired_version       = "latest"
      last_deployed_version = "latest"
      last_build_version    = "init"
    }
  }
}
