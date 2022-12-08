locals {
  settings = {
    storage_size          = 35
    encrypt               = False # Enable encryption at rest for ElasticSearch (only specific instance family types support it: m4, c4, r4, i2, i3 default: false)
    version               = "123"
    instance_size         = "t3.medium.elasticsearch"
    dedicated_master_type = "t3.medium.elasticsearch"
    port                  = 80
    logs_expire           = 7
    production_mode       = False
    data_nodes_count      = 1
    master_nodes_count    = 0
  }
}