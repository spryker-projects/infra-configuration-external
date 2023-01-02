locals {
  secrets = read_terragrunt_config(find_in_parent_folders("secrets/deployment/repoconf.hcl"))
  spryker_repo_conf = {
    type           = "github" # for codecommit change to "codecommit" and set correctly below codecommit parameters
    connection_arn = local.secrets.locals.spryker_repo_conf.connection_arn
    github_token   = local.secrets.locals.spryker_repo_conf.github_token
    description    = "Repository for app"
    # github version
    owner  = local.secrets.locals.spryker_repo_conf.owner
    repo   = "b2b-demo-shop-internal"
    branch = "<template:customer-env>"
    # codecommit parameters
    mirror_exist   =  false
    generate_ssh_credentials = false
  }

  spryker_sdk_repo   = "https://github.com/spryker/docker-sdk"
  spryker_sdk_branch = "master"
}
