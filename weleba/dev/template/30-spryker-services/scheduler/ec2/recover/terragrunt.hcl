include {
  path = find_in_parent_folders()
}

locals {
  spryker-services = read_terragrunt_config(find_in_parent_folders("config/spryker-services/ec2_scheduler.hcl"))
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
}

skip = local.spryker.locals.scheduler_type != "ec2"

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/ec2_recover?ref=v7.0.0"
}

dependency "ec2" {
  config_path = find_in_parent_folders("30-spryker-services/scheduler/ec2/instance")
  mock_outputs = {
    instance_id            = "dummy_instance_id"
  }
}

inputs = {
  project_name  = local.spryker.locals.project_name
  instance_name = local.spryker-services.locals.instance_name
  instance_id   = dependency.ec2.outputs.instance_id
}
