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

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "ecr" {
  config_path = find_in_parent_folders("20-aws-based-infra/ecr")
}

dependency "security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/codebuild")
}

dependency "spryker_variables" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-variables")
}

dependency "spryker_secrets_custom" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/custom-secrets")
}

dependency "spryker_secrets_base" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/base-task-definition")
}

inputs = {
  codebuild_projects_variables = {
    project_name = local.spryker.locals.project_name
  }
  codebuild_projects_config = {
    "pre_deploy" = {
      namebase             = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.namebase
      description          = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.description
      build_timeout        = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.build_timeout
      service_role_arn     = dependency.iam_role.outputs.codebuild_role_arn
      artifacts            = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.artifacts
      secondary_artifact   = null
      secondary_sources    = null
      cache_config         = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.cache_config
      source_template      = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.source_template
      source_template_vars = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.source_template_vars
      source_type          = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.source_type
      secondary_sources    = null
      environment_config = {
        compute_type                = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.environment_config.compute_type
        image                       = dependency.ecr.outputs.repository_urls["boffice"]
        image_pull_credentials_type = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.environment_config.image_pull_credentials_type
        type                        = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.environment_config.type
        privileged_mode             = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.environment_config.privileged_mode
        registry_credential         = local.codebuild-project.locals.codebuild_projects_config.pre_deploy.environment_config.registry_credential
        environment_variables = merge(
          { for k, v in dependency.spryker_variables.outputs.environment_variables["boffice"] : k => { value = v, type = "PLAINTEXT" } },
          { for k, v in dependency.spryker_secrets_base.outputs.ssm_parameter_address : k => { value = v.name, type = "PARAMETER_STORE" } },
          { for k, v in dependency.spryker_secrets_custom.outputs.ssm_parameter_address : k => { value = v.name, type = "PARAMETER_STORE" } },
        )
      }
      vpc_config = {
        vpc_id              = dependency.vpc.outputs.vpc_id
        subnets_ids         = dependency.vpc.outputs.private_cmz_subnet_ids
        security_groups_ids = [dependency.security_group.outputs.security_group]
      }
      tags = {}
    }
  }
}
