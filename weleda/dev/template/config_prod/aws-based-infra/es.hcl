locals {
  settings = {
    storage_size          = 35
    encrypt               = false # Enable encryption at rest for ElasticSearch (only specific instance family types support it: m4, c4, r4, i2, i3 default: false)
    version               = "7.7"
    instance_size         = "t3.medium.elasticsearch"
    dedicated_master_type = "t3.medium.elasticsearch"
    port                  = 80
    logs_expire           = 60
    production_mode       = true
    data_nodes_count      = 2
    master_nodes_count    = 3
  }
}
