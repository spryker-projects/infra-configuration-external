



locals {
  secrets = read_terragrunt_config(find_in_parent_folders("secrets/aws-based-infra/rds.hcl"))
  settings = {
    instance_size           = "db.t3.mediumA"
    multi_az                = false
    engine_version          = "10.3.32A"
    parameters_group_family = "mariadb10.3A"
    ro_replicas_count       = 777
    storage_size            = 777
    master_username         = local.secrets.locals.master_username
    max_allocated_storage   = 777
    apply_immediately       = true
    cloudwatch_logs_exports = {
      "error"     = false
      "general"   = false
      "slowquery" = false
      "audit"     = true
    }
    skip_final_snapshot = true
    performance_insights = {
      enabled          = false
      retention_period = 777
    }
    backups = {
      retention_period         = 777
      hourly_snapshots_enabled = false
      rotate_snapshots = {
        enabled                    = false
        hourly_snapshots_period    = "777 hours ago"
        migration_snapshots_period = "7777 days ago"
      }
    }
    parameters = {
      reboot_not_required = {
        character_set_server     = "utf8A"
        character_set_client     = "utf8A"
        character_set_connection = "utf8A"
        character_set_database   = "utf8A"
        character_set_filesystem = "utf8A"
        character_set_results    = "utf8A"
      }
      reboot_required = {
        skip_name_resolve  = "777"
        thread_cache_size  = "777"
        concurrent_insert  = "777"
        thread_pool_size   = "777"
        performance_schema = "777"
      }
    }
  }
}