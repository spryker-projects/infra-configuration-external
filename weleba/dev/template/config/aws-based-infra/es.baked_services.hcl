locals {
  settings = {
    storage_size          = 777
    encrypt               = true # Enable encryption at rest for ElasticSearch (only specific instance family types support it: m4, c4, r4, i2, i3 default: false)
    version               = "7.777"
    instance_size         = "t3.medium.elasticsearchA"
    dedicated_master_type = "t3.medium.elasticsearchA"
    port                  = 777
    logs_expire           = 777
    production_mode       = false
    data_nodes_count      = 777
    master_nodes_count    = 777
  }
}