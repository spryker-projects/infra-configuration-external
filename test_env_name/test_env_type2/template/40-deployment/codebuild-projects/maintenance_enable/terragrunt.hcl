include {
  path = find_in_parent_folders()
}

locals {
  spryker           = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  codebuild-project = read_terragrunt_config(find_in_parent_folders("config/deployment/codebuild.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_codebuild?ref=development"
}

dependency "iam_role" {
  config_path = find_in_parent_folders("00-initial-infra/iam/codebuild")
}

inputs = {
  codebuild_projects_variables = {
    project_name = local.spryker.locals.project_name
  }
  codebuild_projects_config = {
    "maintenance_enable" = {
      namebase             = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.namebase
      description          = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.description
      build_timeout        = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.build_timeout
      service_role_arn     = dependency.iam_role.outputs.codebuild_role_arn
      artifacts            = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.artifacts
      secondary_artifact   = null
      cache_config         = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.cache_config
      source_template      = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.source_template
      source_template_vars = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.source_template_vars
      source_type          = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.source_type
      environment_config = {
        compute_type                = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.compute_type
        image                       = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.image
        image_pull_credentials_type = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.image_pull_credentials_type
        type                        = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.type
        privileged_mode             = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.privileged_mode
        registry_credential         = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.registry_credential
        environment_variables = {
          SPRYKER_PROJECT_NAME = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.environment_variables.SPRYKER_PROJECT_NAME
          SPRYKER_FEATURES     = local.codebuild-project.locals.codebuild_projects_config.maintenance_enable.environment_config.environment_variables.SPRYKER_FEATURES
        }
      }
      secondary_sources = null
      vpc_config = null
      tags = {}
    }
  }
}
