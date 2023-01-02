locals {
  settings = {
    "instance_size"              = "cache.t3.medium" # previously t2.medium, BTW, are we really need medium (3 Gb) Redis on stage envs? We can use small (1.37 Gb)
    "port"                       = 6379
    "number_cache_clusters"      = 1       # must be at least 2 if multi_az_enabled = TRUE
    "engine_version"             = "3.2.6" # newest is 3.2.10
    "parameter_group_family"     = "redis3.2"
    "multi_az_enabled"           = false # When set to TRUE, make Terraform Apply, then set "automatic_failover_enabled" to TRUE and make Terraform Apply again
    "automatic_failover_enabled" = false # Must be set to FALSE if updating 1 node cluster and set to TRUE if multi_az_enabled is set to TRUE
    "database_limit"             = 200
    "snapshot_retention_limit"   = "7"
    "encryption_at_rest"         = true
    "encryption_in_transit"      = false
    "apply_immediately"          = true
  }
}