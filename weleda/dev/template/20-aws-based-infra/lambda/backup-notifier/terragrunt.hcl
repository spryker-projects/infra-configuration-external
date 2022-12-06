include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  aws-based-infra = read_terragrunt_config(find_in_parent_folders("config/aws-based-infra/lambda.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lambda/backup_notifier?ref=v7.0.0"
}

dependency "rds" {
  config_path = find_in_parent_folders("00-initial-infra/iam/rds")
}

inputs = {
  project_name                            = local.spryker.locals.project_name
  route53_zone_domain                     = local.spryker.locals.route53_zone_domain
  rds_backup_notifier_lambda_role_arn     = dependency.rds.outputs.rds_backup_notifier_lambda_role_arn
  recipient                               = local.aws-based-infra.locals.backup-notifier.recipient
  sns_rds_snapshot_arn                    = dependency.rds.outputs.sns_rds_snapshot_arn
  sns_rds_snapshot_codebuild_failures_arn = dependency.rds.outputs.sns_rds_snapshot_codebuild_failures_arn
}
