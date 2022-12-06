locals {
  #00-initial-infra/02-iam/02-service-linked-roles
  slr = {
    enable_es_role  = false
    enable_ssm_role = false
    # Old installation change to "AWSServiceRoleForAmazonElasticsearchService"
    elasticsearch_role_name = "AWSServiceRoleForAmazonOpenSearchService"
  }
  ssm = {
    apply_rollback = false
  }
  customer = {
    additional_policy_arns = []
  }
}
