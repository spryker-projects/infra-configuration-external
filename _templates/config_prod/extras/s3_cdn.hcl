locals {
    spryker       = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
    enabled       = false
    s3_buckets = [
        {
            bucket_name             = "${local.spryker.locals.project_name}-cdn"
            versioning_enabled      = false
            lifecycle_old_versions  = -1
            bucket_user_name        = null
            create_extra_group      = false
            extra_group_policy_json = null
            cdn_domain              = "cdn.${local.spryker.locals.route53_zone_domain}"
            create_route53_record   = false
            default_cache_ttl       = 7200
            acm_certificate_arn     = null
        },
        {
            bucket_name             = "${local.spryker.locals.project_name}-feed"
            versioning_enabled      = false
            lifecycle_old_versions  = -1
            bucket_user_name        = null
            create_extra_group      = false
            extra_group_policy_json = null
            cdn_domain              = "feed.${local.spryker.locals.route53_zone_domain}"
            create_route53_record   = false
            default_cache_ttl       = 7200
            acm_certificate_arn     = null
        }
    ]
}
