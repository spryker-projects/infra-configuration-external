
locals {
  spryker = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  confd = {
    confd = "${get_parent_terragrunt_dir()}/../../../conf.d"
  }
  newrelic = {
    jenkins_hostname                = "localhost"
    jenkins_tcpport                 = "8080"
    jenkins_minimum_version         = "2.289"
    newrelic_jenkins_plugin_version = "1.0.4"
  }
  generic = {
    s3_settings = {
      bucket_name =  ""
      bucket_type  = "private"
      lifecycle_old_versions = 90
      versioning_enabled = true
  }
  }
}
