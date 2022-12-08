include {
  path = find_in_parent_folders()
}

locals {
  spryker       = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  repoconf      = read_terragrunt_config(find_in_parent_folders("config/deployment/repoconf.hcl"))
  codepipelines_ec2 = read_terragrunt_config(find_in_parent_folders("config/deployment/codepipelines.hcl"))
  codepipelines_ecs = read_terragrunt_config(find_in_parent_folders("config/deployment/codepipelines-ecs-scheduler.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/aws_codepipeline?ref=v7.0.0"
}

dependency "iam_role" {
  config_path = find_in_parent_folders("00-initial-infra/iam/codebuild")
}

dependency "codedeploy" {
  config_path = find_in_parent_folders("40-deployment/codedeploy-jenkins")
}

dependency "sns_topics" {
  config_path = find_in_parent_folders("00-initial-infra/sns_topics/pipeline_approval")
}

inputs = {
  project_name               = local.spryker.locals.project_name
  pipeline_type              = local.spryker.locals.scheduler_type == "ecs" ? local.codepipelines_ecs.locals.codepipelines_config.destructive.pipeline_type : local.codepipelines_ec2.locals.codepipelines_config.destructive.pipeline_type 
  run_stages                 = local.spryker.locals.scheduler_type == "ecs" ? local.codepipelines_ecs.locals.codepipelines_config.destructive.run_stages : local.codepipelines_ec2.locals.codepipelines_config.destructive.run_stages
  restart_services           = local.spryker.locals.services_to_restart
  service_role_arn           = dependency.iam_role.outputs.codebuild_role_arn
  spryker_repo_conf          = local.repoconf.locals.spryker_repo_conf
  scheduler_settings = {
    provider      = local.spryker.locals.scheduler_type == "ecs" ? local.codepipelines_ecs.locals.codepipelines_config.destructive.scheduler_settings.provider : local.codepipelines_ec2.locals.codepipelines_config.destructive.scheduler_settings.provider
    configuration = local.spryker.locals.scheduler_type == "ecs" ? local.codepipelines_ecs.locals.codepipelines_config.destructive.scheduler_settings.configuration : local.codepipelines_ec2.locals.codepipelines_config.destructive.scheduler_settings.configuration
  }
  sns_notification_topic_arn = dependency.sns_topics.outputs.aws_sns_topic_arn
}
