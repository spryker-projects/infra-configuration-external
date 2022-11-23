include {
  path = find_in_parent_folders()
}

locals {
  spryker           = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  codebuild-project = read_terragrunt_config(find_in_parent_folders("config/deployment/codebuild.hcl"))
  evm               = read_terragrunt_config(find_in_parent_folders("config/common/evm.hcl"))
  sdk_vars          = read_terragrunt_config(find_in_parent_folders("environment.tf"))
  customer_name     = local.spryker.locals.project_owner
  customer_env      = local.spryker.locals.env_type
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

dependency "spryker_secrets_custom" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/custom-secrets")
}

dependency "spryker_secrets_base" {
  config_path = find_in_parent_folders("30-spryker-services/spryker-environment/spryker-secrets/base-task-definition")
}

dependency "s3" {
  config_path = find_in_parent_folders("00-initial-infra/s3/conf.d")
}

inputs = {
  codebuild_projects_variables = {
    project_name                   = local.spryker.locals.project_name
    project_owner                  = local.spryker.locals.project_owner
    checked_services               = jsonencode(([for k in keys(local.sdk_vars.locals.spryker_environment) : lower(k)]))
    services                       = jsonencode(local.spryker.locals.spryker_ecr_repos)
    enable_jenkins_on_ecs          = local.spryker.locals.scheduler_type == "ecs" ? true : false
    docker_registry_type           = local.codebuild-project.locals.docker_registry_type
    aws_account_id                 = dependency.aws_data.outputs.account_id
    hash_id                        = local.codebuild-project.locals.hash_id
    ssm_custom_secrets_path_prefix = "/${local.spryker.locals.project_name}/custom-secrets"
    SSM_PATHS                      = join(" ", concat(local.evm.locals.ssm_paths_env_vars.common, local.evm.locals.ssm_paths_env_vars.scheduler, local.evm.locals.ssm_paths_secrets.common, local.evm.locals.ssm_paths_secrets.scheduler))
    deploy_file                    = local.codebuild-project.locals.deploy_file
  }
  codebuild_projects_config = {
    "app_build" = {
      namebase          = local.codebuild-project.locals.codebuild_projects_config.app_build.namebase
      description       = local.codebuild-project.locals.codebuild_projects_config.app_build.description
      build_timeout     = local.codebuild-project.locals.codebuild_projects_config.app_build.build_timeout
      service_role_arn  = dependency.iam_role.outputs.codebuild_role_arn
      artifacts         = local.codebuild-project.locals.codebuild_projects_config.app_build.artifacts
      secondary_sources = null
      secondary_artifact = {
        name                = local.codebuild-project.locals.codebuild_projects_config.app_build.secondary_artifact.name
        type                = local.codebuild-project.locals.codebuild_projects_config.app_build.secondary_artifact.type
        artifact_identifier = local.codebuild-project.locals.codebuild_projects_config.app_build.secondary_artifact.artifact_identifier
        path                = local.codebuild-project.locals.codebuild_projects_config.app_build.secondary_artifact.path
        packaging           = local.codebuild-project.locals.codebuild_projects_config.app_build.secondary_artifact.packaging
        location            = dependency.s3.outputs.codebuild_s3_bucket_name
      }
      cache_config         = local.codebuild-project.locals.codebuild_projects_config.app_build.cache_config
      source_template      = local.codebuild-project.locals.codebuild_projects_config.app_build.source_template
      source_template_vars = local.codebuild-project.locals.codebuild_projects_config.app_build.source_template_vars
      source_type          = local.codebuild-project.locals.codebuild_projects_config.app_build.source_type
      environment_config = {
        compute_type                = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.compute_type
        image                       = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.image
        image_pull_credentials_type = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.image_pull_credentials_type
        type                        = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.type
        privileged_mode             = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.privileged_mode
        registry_credential         = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.registry_credential
        environment_variables = merge({
          ENVIRONMENT_VARIABLES = {
            value = base64gzip(jsonencode({
              "ENVIRONMENT_VARIABLES" = merge(
                dependency.spryker_variables.outputs.environment_variables["boffice"],
                dependency.spryker_variables.outputs.environment_variables["jenkins"],
                { for k, v in dependency.spryker_secrets_base.outputs.ssm_parameter_address : k => v.value }
              )
              AWS_REGION           = "${local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.AWS_REGION.value}"
              PROJECT_NAME         = "${local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.PROJECT_NAME.value}"
              SFTP_EFS_MOUNT_POINT = "${local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.SFTP_EFS_MOUNT_POINT.value}"
              NEWRELIC_INTEGRATION = "${local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.NEWRELIC_INTEGRATION.value}"
              NRIA_LICENSE_KEY     = "${local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.NRIA_LICENSE_KEY.value}"
          })), type = "PLAINTEXT" } },
          { for k, v in dependency.spryker_secrets_base.outputs.ssm_parameter_address : k => { value = v.name, type = "PARAMETER_STORE" } },
          { for k, v in dependency.spryker_secrets_custom.outputs.ssm_parameter_address : k => { value = v.name, type = "PARAMETER_STORE" } },
          { for k, v in dependency.ecr.outputs.repository_urls : "${upper(k)}_ECR_REPO" => { value = v, type = "PLAINTEXT" } },
          {
            PROJECT_NAME             = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.SPRYKER_PROJECT_NAME
            SPRYKER_PROJECT_NAME     = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.SPRYKER_PROJECT_NAME
            INIT_IMAGE_PREFIX        = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.INIT_IMAGE_PREFIX
            GRACEFUL_SHUTDOWN_PERIOD = local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.GRACEFUL_SHUTDOWN_PERIOD
            JENKINS_IMAGE            = { value = "${dependency.ecr.outputs.repository_urls["jenkins"]}", type = "PLAINTEXT" }
            SFTP_EFS_MOUNT_POINT     = local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.SFTP_EFS_MOUNT_POINT
            AWS_REGION               = local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.AWS_REGION
            NEWRELIC_INTEGRATION     = local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.NEWRELIC_INTEGRATION
            NRIA_LICENSE_KEY         = local.codebuild-project.locals.codebuild_projects_config.scheduler.environment_config.environment_variables.NRIA_LICENSE_KEY
            REGION                   = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.REGION
            SPRYKER_SDK_REPO         = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.SPRYKER_SDK_REPO
            SPRYKER_SDK_BRANCH       = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.SPRYKER_SDK_BRANCH
            JENKINS_ECR_REPO         = { value = "${dependency.ecr.outputs.repository_urls["jenkins"]}", type = "PLAINTEXT" }
            GITHUB_TOKEN             = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.GITHUB_TOKEN
            DOCKERHUB_USERNAME       = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.DOCKERHUB_USERNAME
            DOCKERHUB_PASSWORD       = local.codebuild-project.locals.codebuild_projects_config.app_build.environment_config.environment_variables.DOCKERHUB_PASSWORD
        })
      }
      vpc_config = {
        vpc_id              = dependency.vpc.outputs.vpc_id
        subnets_ids         = dependency.vpc.outputs.private_cmz_subnet_ids
        security_groups_ids = [dependency.security_group.outputs.security_group]
      }
      tags       = {}
    }
  }

}
