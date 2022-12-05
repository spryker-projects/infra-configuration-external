locals {
  secrets                                          = read_terragrunt_config(find_in_parent_folders("secrets/extras/gmv_and_composer_shared.hcl"))
  gmv_and_composer_content_repo                    = "github.com/spryker-projects/spryker-data-extraction.git"
  aws_environment_email                            = "<template:change-me>"
  gmv_enabled                                      = false
  gmv_and_composer_content_github_token            = local.secrets.locals.gmv_and_composer_content_github_token
  gmv_and_composer_content_bucket_secrets          = local.secrets.locals.gmv_and_composer_content_bucket_secrets
  lambda_spryker_enabled_features_endpoint_api_key = local.secrets.locals.lambda_spryker_enabled_features_endpoint_api_key
}
