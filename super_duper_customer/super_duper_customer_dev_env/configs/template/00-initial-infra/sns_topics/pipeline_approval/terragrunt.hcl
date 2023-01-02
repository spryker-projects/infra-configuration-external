include {
  path = find_in_parent_folders()
}

locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  sns     = read_terragrunt_config(find_in_parent_folders("config/initial-infra/sns.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/sns_topics/pipeline_approval?ref=v7.0.0"
}

inputs = {
  project_name            = local.spryker.locals.project_name
  sns_notification_emails = local.sns.locals.sns_notification_emails
}
