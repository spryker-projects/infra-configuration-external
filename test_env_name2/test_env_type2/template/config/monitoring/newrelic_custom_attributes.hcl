locals {
    spryker  = read_terragrunt_config(find_in_parent_folders("common/spryker.hcl"))
    nria_custom_atrributes = {
      "DeployMethod": "downloadPage",
      "tags.aws_account_id": get_aws_account_id(),
      "tags.aws_account_environment": local.spryker.locals.aws_account_environment,
      "tags.release_version":local.spryker.locals.released_version,
      "tags.customer_name": local.spryker.locals.project_owner,
      "tags.account_name": local.spryker.locals.project_name,
      "tags.aws_region": local.spryker.locals.region
    }
}

