locals {
  secrets = read_terragrunt_config(find_in_parent_folders("secrets/aws-based-infra/rds.hcl"))
  settings = {
    instance_size           = "db.t3.medium"
    multi_az                = False
    engine_version          = "bbb"
    parameters_group_family = "mariadb10.3"
    storage_size            = 100
    master_username         = local.secrets.locals.master_username
    max_allocated_storage   = 0
    apply_immediately       = true
    cloudwatch_logs_exports = {
      "error"     = true
      "general"   = true
      "slowquery" = true
      "audit"     = false
    }
    skip_final_snapshot = true
    performance_insights = {
      enabled          = true
      retention_period = 7
    }
    backups = {
      retention_period         = 28
      hourly_snapshots_enabled = True
      rotate_snapshots = {
        enabled                    = True
        hourly_snapshots_period    = "60 hours ago"
        migration_snapshots_period = "7 days ago"
      }
    }
    parameters = {
      reboot_not_required = {
        character_set_server     = "utf8"
        character_set_client     = "utf8"
        character_set_connection = "utf8"
        character_set_database   = "utf8"
        character_set_filesystem = "utf8"
        character_set_results    = "utf8"
      }
      reboot_required = {
        skip_name_resolve  = "1"
        thread_cache_size  = "4"
        concurrent_insert  = "1"
        thread_pool_size   = "32"
        performance_schema = "1"
      }
    }
  }
}