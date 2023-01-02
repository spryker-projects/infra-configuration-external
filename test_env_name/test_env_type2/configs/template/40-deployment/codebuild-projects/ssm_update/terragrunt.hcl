include {
  path = find_in_parent_folders()
}

locals {
  spryker           = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  codebuild-project = read_terragrunt_config(find_in_parent_folders("config/deployment/codebuild.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_codebuild?ref=v7.0.0"
}

dependency "iam_role" {
  config_path = find_in_parent_folders("00-initial-infra/iam/codebuild")
}

dependency "dockerhub_creds" {
  config_path = find_in_parent_folders("00-initial-infra/secrets-manager/dockerhub-creds")
}

dependency "aws_data" {
  config_path = find_in_parent_folders("00-initial-infra/aws-data")
}

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/codebuild")
}

dependency "ecr" {
  config_path = find_in_parent_folders("20-aws-based-infra/ecr")
}

dependency "spryker_variables" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-variables")
}

dependency "spryker_secrets_base" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/base-task-definition")
}

inputs = {
  codebuild_projects_variables = {
    project_name = local.spryker.locals.project_name
  }
  codebuild_projects_config = {
    "ssm_update" = {
      namebase             = local.codebuild-project.locals.codebuild_projects_config.ssm_update.namebase
      description          = local.codebuild-project.locals.codebuild_projects_config.ssm_update.description
      build_timeout        = local.codebuild-project.locals.codebuild_projects_config.ssm_update.build_timeout
      service_role_arn     = dependency.iam_role.outputs.codebuild_role_arn
      artifacts            = local.codebuild-project.locals.codebuild_projects_config.ssm_update.artifacts
      secondary_artifact   = null
      secondary_sources    = null
      cache_config         = local.codebuild-project.locals.codebuild_projects_config.ssm_update.cache_config
      source_template      = local.codebuild-project.locals.codebuild_projects_config.ssm_update.source_template
      source_template_vars = local.codebuild-project.locals.codebuild_projects_config.ssm_update.source_template_vars
      source_type          = local.codebuild-project.locals.codebuild_projects_config.ssm_update.source_type
      environment_config = {
        compute_type                = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.compute_type
        image                       = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.image
        image_pull_credentials_type = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.image_pull_credentials_type
        type                        = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.type
        privileged_mode             = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.privileged_mode
        registry_credential         = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.registry_credential
        environment_variables       = local.codebuild-project.locals.codebuild_projects_config.ssm_update.environment_config.environment_variables
      }
      vpc_config = null
      tags       = {}
    }
  }
}
