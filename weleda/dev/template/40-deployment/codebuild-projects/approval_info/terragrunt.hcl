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

dependency "vpc" {
  config_path = find_in_parent_folders("10-network/vpc")
}

dependency "security_group" {
  config_path = find_in_parent_folders("10-network/security_groups/codebuild")
}

inputs = {
  codebuild_projects_variables = {
    project_name = local.spryker.locals.project_name
  }
  codebuild_projects_config = {
    "approval_info" = {
      namebase             = local.codebuild-project.locals.codebuild_projects_config.approval_info.namebase
      description          = local.codebuild-project.locals.codebuild_projects_config.approval_info.description
      build_timeout        = local.codebuild-project.locals.codebuild_projects_config.approval_info.build_timeout
      service_role_arn     = dependency.iam_role.outputs.codebuild_role_arn
      artifacts            = local.codebuild-project.locals.codebuild_projects_config.approval_info.artifacts
      secondary_artifact   = null
      secondary_sources    = null
      cache_config         = local.codebuild-project.locals.codebuild_projects_config.approval_info.cache_config
      source_template      = local.codebuild-project.locals.codebuild_projects_config.approval_info.source_template
      source_template_vars = local.codebuild-project.locals.codebuild_projects_config.approval_info.source_template_vars
      source_type          = local.codebuild-project.locals.codebuild_projects_config.approval_info.source_type
      environment_config   = local.codebuild-project.locals.codebuild_projects_config.approval_info.environment_config
      vpc_config = {
        vpc_id              = dependency.vpc.outputs.vpc_id
        subnets_ids         = dependency.vpc.outputs.private_cmz_subnet_ids
        security_groups_ids = [dependency.security_group.outputs.security_group]
      }
      tags = {}
    }
  }
}
