

include {
  path = find_in_parent_folders()
}

locals {
  spryker              = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  composer_content     = read_terragrunt_config(find_in_parent_folders("config/extras/composer_content.hcl"))
  gmv_cc_shared        = read_terragrunt_config(find_in_parent_folders("config/extras/gmv_and_composer_shared.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/spryker_secrets_manager?ref=v7.0.0"
}

skip = !local.gmv_cc_shared.locals.gmv_enabled

dependency "rds" {
  config_path = find_in_parent_folders("20-aws-based-infra/rds")
}

inputs = {
  project_name    = local.spryker.locals.project_name
  secret_name     = "gmv_and_cc_secrets"
  secret_contents = merge(
    local.gmv_cc_shared.locals.gmv_and_composer_content_bucket_secrets,
    {
      "host": length(dependency.rds.outputs.replica_endpoints) > 0 ? dependency.rds.outputs.replica_endpoints[0] : "",  
      "port": dependency.rds.outputs.port,
      "username": dependency.rds.outputs.username,
      "password": dependency.rds.outputs.db_password,
      "dbname": dependency.rds.outputs.db_name
    }
  )
}
