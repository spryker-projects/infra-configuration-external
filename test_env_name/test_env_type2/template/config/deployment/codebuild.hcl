locals {
  spryker                          = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  newrelic                         = read_terragrunt_config(find_in_parent_folders("config/monitoring/newrelic.hcl"))
  repoconf                         = read_terragrunt_config(find_in_parent_folders("config/deployment/repoconf.hcl"))
  secrets                          = read_terragrunt_config(find_in_parent_folders("secrets/deployment/codebuild.hcl"))
  secrets_common                   = read_terragrunt_config(find_in_parent_folders("secrets/common/secrets.hcl"))
  INIT_IMAGE_PREFIX                = "spryker-cloud"
  JENKINS_GRACEFUL_SHUTDOWN_PERIOD = "600"
  jenkins_sftp_efs_mount_point     = "1"
  secret_name                      = local.secrets.locals.secret_name
  dockerhub_username               = local.secrets.locals.dockerhub_username
  dockerhub_password               = local.secrets.locals.dockerhub_password
  SPRYKER_BROKER_ADDITIONAL_USERS  = local.secrets.locals.SPRYKER_BROKER_ADDITIONAL_USERS
  docker_registry_type             = "DOCKER_HUB"
  PROVISION_ECR_REPO               = "spryker/provision:1.1.0"
  hash_id                          = local.secrets.locals.hash_id
  deploy_file                      = local.spryker.locals.deploy_file
  codebuild_projects_config = {
    "approval_info" = {
      namebase      = "Update_pipeline_approval_info"
      description   = "Add info about App versions to Approval step of Pipeline"
      build_timeout = 360
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }

      cache_config = null
      environment_config = {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "CODEBUILD"
        type                        = "LINUX_CONTAINER"
        privileged_mode             = false
        registry_credential         = null
        environment_variables = {
          GIT_REPO_URL = {
            type  = "PLAINTEXT"
            value = "/${local.spryker.locals.project_name}/codebuild/git_repo_url"
          }
        }
      }
      source_template      = "codebuild_custom_approval_message.yml.tmpl"
      source_template_vars = ["project_name"]
      source_type          = "CODEPIPELINE"
    }
    "app_build" = {
      namebase      = "Build_spryker_app_for"
      description   = "Build Spryker app image"
      build_timeout = 60
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      secondary_artifact = {
        type                = "S3"
        artifact_identifier = "dockersdk_provision"
        path                = "provision"
        name                = "dockersdk_provision"
        packaging           = "ZIP"
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_LARGE"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
        environment_variables = {
          SPRYKER_PROJECT_NAME      = { value = "${local.spryker.locals.project_name}", type = "PLAINTEXT" }
          SPRYKER_MAIL_SENDER_EMAIL = { value = "noreply@${local.spryker.locals.route53_zone_domain}", type = "PLAINTEXT" }
          REGION                    = { value = "${local.spryker.locals.region}", type = "PLAINTEXT" }
          SPRYKER_SDK_REPO          = { value = "${local.repoconf.locals.spryker_sdk_repo}", type = "PLAINTEXT" }
          SPRYKER_SDK_BRANCH        = { value = "${local.repoconf.locals.spryker_sdk_branch}", type = "PLAINTEXT" }
          INIT_IMAGE_PREFIX         = { value = "${local.INIT_IMAGE_PREFIX}", type = "PLAINTEXT" }
          GITHUB_TOKEN              = { value = "${local.repoconf.locals.spryker_repo_conf.github_token}", type = "PLAINTEXT" }
          DOCKERHUB_USERNAME        = { value = "dockerhub_credentials_${local.spryker.locals.project_name}:username", type = "SECRETS_MANAGER" }
          DOCKERHUB_PASSWORD        = { value = "dockerhub_credentials_${local.spryker.locals.project_name}:password", type = "SECRETS_MANAGER" }
        }
      }
      source_template = "codebuild_spryker_app_buildspec.yml.tmpl"
      source_template_vars = [
        "project_name",
        "project_owner",
        "docker_registry_type",
        "checked_services",
        "enable_jenkins_on_ecs",
        "ssm_custom_secrets_path_prefix",
        "services",
        "aws_account_id",
        "SSM_PATHS",
        "hash_id",
        "deploy_file"
      ]
      source_type = "CODEPIPELINE"
    }
    "ssm_update" = {
      namebase      = "Update_latest_deployed_version_of"
      description   = "Update LATEST_DEPLOYED_VERSION value in Parameter store"
      build_timeout = 20
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = null
      environment_config = {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
        environment_variables = {
        }
      }
      source_template      = "codebuild_update_deployed_version.yml.tmpl"
      source_template_vars = ["project_name"]
      source_type          = "CODEPIPELINE"
    }
    "pre_deploy" = {
      namebase      = "Run_pre-deploy_for"
      description   = "vendor/bin/install -r pre-deploy"
      build_timeout = 20
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_pre-deploy_hook.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
      secondary_sources    = null
    }
    "pre_deploy_config" = {
      namebase      = "Pre_deploy_config_for"
      description   = "Pre deploy config"
      build_timeout = 360
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = "dockersdk_provision"
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "SERVICE_ROLE"
        image                       = local.PROVISION_ECR_REPO
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_pre_deploy_config_buildspec.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
      secondary_sources = {
        type              = "S3"
        source_identifier = "dockersdk_provision"
        location_suffix   = "/provision/dockersdk_provision"
      }
    }
    "post_deploy_config" = {
      namebase      = "Post_deploy_config_for"
      description   = "Post deploy config"
      build_timeout = 360
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = "dockersdk_provision"
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "SERVICE_ROLE"
        image                       = local.PROVISION_ECR_REPO
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_post_deploy_config_buildspec.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
      secondary_sources = {
        type              = "S3"
        source_identifier = "dockersdk_provision"
        location_suffix   = "/provision/dockersdk_provision"
      }
    }
    "post_deploy" = {
      namebase      = "Run_post-deploy_for"
      description   = "vendor/bin/install -r post-deploy"
      build_timeout = 20
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_post-deploy_hook.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
    }
    "install" = {
      namebase      = "Run_install_for"
      description   = "vendor/bin/install"
      build_timeout = 20
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_LARGE"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_install_buildspec.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
    }
    "scheduler" = {
      namebase      = "Prepare_appspec_for_scheduler_codedeploy"
      description   = "appspec.yml for codedeploy"
      build_timeout = 20
      artifacts = {
        type                = "NO_ARTIFACTS"
        artifact_identifier = null
      }
      cache_config = null
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "CODEBUILD"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = false
        environment_variables = {
          AWS_REGION               = { value = "${local.spryker.locals.region}", type = "PLAINTEXT" }
          PROJECT_NAME             = { value = "${local.spryker.locals.project_name}", type = "PLAINTEXT" }
          GRACEFUL_SHUTDOWN_PERIOD = { value = "${local.JENKINS_GRACEFUL_SHUTDOWN_PERIOD}", type = "PLAINTEXT" }
          NEWRELIC_INTEGRATION     = { value = "${local.newrelic.locals.newrelic_integration.enable_integration}", type = "PLAINTEXT" }
          NRIA_LICENSE_KEY         = { value = "${local.newrelic.locals.newrelic_integration.license_key}", type = "PLAINTEXT" }
          SFTP_EFS_MOUNT_POINT     = { value = "${local.jenkins_sftp_efs_mount_point}", type = "PLAINTEXT" }
        }
      }
      source_template_vars = ["project_name", "ssm_custom_secrets_path_prefix", "SSM_PATHS"]
      source_type          = "NO_SOURCE"
    }
    "scheduler_setup" = {
      namebase      = "Setup_scheduler_for"
      description   = "vendor/bin/console scheduler:*"
      build_timeout = 60
      artifacts = {
        type                = "NO_ARTIFACTS"
        artifact_identifier = null
      }
      cache_config = null
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image                       = "aws/codebuild/standard:4.0"
        image_pull_credentials_type = "SERVICE_ROLE"
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
      }
      source_template      = "codebuild_scheduler_buildspec.yml.tmpl"
      source_template_vars = ["project_name"]
      source_type          = "NO_SOURCE"
    }
    "maintenance_enable" = {
      namebase      = "Maintenance_enable_for"
      description   = "Maintenance enable"
      build_timeout = 60
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "SERVICE_ROLE"
        image                       = local.PROVISION_ECR_REPO
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
        environment_variables = {
          SPRYKER_PROJECT_NAME = { value = "${local.spryker.locals.project_name}", type = "PLAINTEXT" }
          SPRYKER_FEATURES     = { value = try("${local.secrets_common.locals.spryker_secrets.SPRYKER_FEATURES}", "{}"), type = "PLAINTEXT" }
        }
      }
      source_template      = "codebuild_maintenance_enable.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
    }
    "maintenance_disable" = {
      namebase      = "Maintenance_disable_for"
      description   = "Maintenance disable"
      build_timeout = 60
      artifacts = {
        type                = "CODEPIPELINE"
        artifact_identifier = null
      }
      cache_config = {
        "type"  = "LOCAL"
        "modes" = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
      }
      environment_config = {
        compute_type                = "BUILD_GENERAL1_MEDIUM"
        image_pull_credentials_type = "SERVICE_ROLE"
        image                       = local.PROVISION_ECR_REPO
        registry_credential         = null
        type                        = "LINUX_CONTAINER"
        privileged_mode             = true
        environment_variables = {
          SPRYKER_PROJECT_NAME = { value = "${local.spryker.locals.project_name}", type = "PLAINTEXT" }
          SPRYKER_FEATURES     = { value = try("${local.secrets_common.locals.spryker_secrets.SPRYKER_FEATURES}", "{}"), type = "PLAINTEXT" }
        }
      }
      source_template      = "codebuild_maintenance_disable.yml.tmpl"
      source_template_vars = []
      source_type          = "CODEPIPELINE"
    }
  }
}
