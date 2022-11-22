locals {
  spryker  = read_terragrunt_config("${get_parent_terragrunt_dir()}/config/common/spryker.hcl")
  secrets  = read_terragrunt_config("${get_parent_terragrunt_dir()}/config/common/secrets.hcl")
  newrelic = read_terragrunt_config("${get_parent_terragrunt_dir()}/config/monitoring/newrelic.hcl")

  # following map is used to override default provider version constraints
  # for the purposes of the migration process (limiting bastion and jenkins downtime), following must be set: 
  provider_version_overrides = {}
}

remote_state {
  backend = "s3"
  config = {
    # disable_bucket_update = true         # needs to be uncommented when using terragrunt >= v0.37.0
    region         = "eu-central-1"        # this region cannot be changed, it's only for the spryker-tf-states bucket
    bucket         = "spryker-tf-states"   # we keep all states in one bucket
    dynamodb_table = "spryker-tf-lock"
    key            = "${local.spryker.locals.project_owner}/${local.spryker.locals.env_type}/${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  region = local.spryker.locals.region
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    # You can uncomment it on local machine if needed, but keep in mind the concurrency of different version for different envs
    #env_vars = {
    #  TF_PLUGIN_CACHE_DIR = "${get_env("HOME")}/.tf_plugins_cache",
    #}

  }
}

generate "backend" {
  path              = "backend.tf"
  if_exists         = "overwrite"
  disable_signature = true
  contents          = <<EOF

terraform {
  backend "s3" {}
}

EOF
}

generate "providers" {
  path              = "providers.tf"
  if_exists         = "overwrite"
  disable_signature = true
  contents = templatefile("providers.tftpl", {

    provider_version_constraints = {
      aws      = lookup(lookup(local.provider_version_overrides, path_relative_to_include(), {}), "aws", "~> 4.17")
      template = lookup(lookup(local.provider_version_overrides, path_relative_to_include(), {}), "template", "~> 2.2.0")
      newrelic = lookup(lookup(local.provider_version_overrides, path_relative_to_include(), {}), "newrelic", "~> 2.48")
      vault    = lookup(lookup(local.provider_version_overrides, path_relative_to_include(), {}), "vault", "~> 2.16.0")
    }

    provider_parameters = {
      aws_region               = local.spryker.locals.region
      aws_account_id           = get_aws_account_id()
      aws_account_name         = local.spryker.locals.project_name
      aws_account_environment  = local.spryker.locals.aws_account_environment
      customer_name            = local.spryker.locals.project_owner
      release_version          = local.spryker.locals.released_version
      hashicorp_vault_password = local.secrets.locals.hashicorp_vault_password
      newrelic_account_id      = local.newrelic.locals.newrelic_integration.account_id
      newrelic_api_key         = local.newrelic.locals.newrelic_integration.api_key
    }

  })
}
