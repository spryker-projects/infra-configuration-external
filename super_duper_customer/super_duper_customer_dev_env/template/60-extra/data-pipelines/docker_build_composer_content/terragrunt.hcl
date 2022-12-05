include {
  path = find_in_parent_folders()
}

locals {
  spryker              = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  composer_content     = read_terragrunt_config(find_in_parent_folders("config/extras/composer_content.hcl"))
  gmv_cc_shared        = read_terragrunt_config(find_in_parent_folders("config/extras/gmv_and_composer_shared.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/docker_build?ref=v7.0.0"
}

skip = !local.gmv_cc_shared.locals.gmv_enabled

dependency "github_clone" {
  config_path = find_in_parent_folders("60-extra/data-pipelines/github_clone")
  mock_outputs = {
    repo_dir       = "dummy_repo"
  }
}

inputs = {
  docker_image_tag = local.composer_content.locals.docker_image_tag
  dockerfile_dir   = "${dependency.github_clone.outputs.repo_dir}/composer_content"
  repo_name        = "${local.spryker.locals.project_name}-composer-content"
}
