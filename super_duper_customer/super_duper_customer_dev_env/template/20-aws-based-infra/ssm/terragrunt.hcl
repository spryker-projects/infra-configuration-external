include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  aws-based-infra = read_terragrunt_config(find_in_parent_folders("config/aws-based-infra/ssm.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/ssm?ref=v7.0.0"
}

dependency "iam_slr" {
  config_path = find_in_parent_folders("00-initial-infra/iam/service-linked-roles")
}

dependency "iam_ssm" {
  config_path = find_in_parent_folders("00-initial-infra/iam/ssm")
}

dependency "s3_ssm" {
  config_path = find_in_parent_folders("00-initial-infra/s3/ssm")
}

dependency "ssm" {
  config_path = find_in_parent_folders("00-initial-infra/ssm")
}

dependency "ec2_bastion" {
  config_path = find_in_parent_folders("10-network/ec2/bastion")
}

inputs = {
  project_name                     = local.spryker.locals.project_name
  ansible                          = local.aws-based-infra.locals.ansible
  schedule                         = local.aws-based-infra.locals.schedule
  apply_rollback                   = local.aws-based-infra.locals.apply_rollback
  ssm_service_linked_role_arn      = dependency.iam_slr.outputs.ssm_service_linked_role_arn
  bastion_id                       = dependency.ec2_bastion.outputs.instance_id
  ssm_automation_iam_role_arn      = dependency.iam_ssm.outputs.ssm_automation_iam_role_arn
  ssm_ansible_s3_bucket_name       = dependency.s3_ssm.outputs.ssm_ansible_s3_bucket_name
  ssm_ansible_parameter_address_id = dependency.ssm.outputs.ssm_parameter_address.ssm_ansible_password.id
}
