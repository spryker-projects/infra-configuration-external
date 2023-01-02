locals {
  common = {
    "default_widget_sizes" = {
      "widget_width"  = "6"
      "widget_height" = "6"
    }
    "http_responses" = [
      "HTTPCode_Target_2XX_Count",
      "HTTPCode_Target_4XX_Count",
      "HTTPCode_Target_5XX_Count"
    ]
    "widget_title" = {
      "http_responses_widget" : "HTTP Responses"
      "http_response_time_widget" : "HTTP Response time"
      "ecs_services_mem_widget" : "ECS MemoryUtilization"
      "ecs_services_cpu_widget" : "ECS CPUUtilization"
      "rds_r_w_latency_widget" : "RDS Read-WriteLatency"
      "rds_r_w_iops_widget" : "RDS Read-WriteIOPS"
      "es_documents_widget" : "ES Deleted Searchable Documents"
      "es_latency_wirget" : "ES Indexing-Search Latency"
      "es_cpu_widget" : "ES CPUUtilization"
      "es_mem_widget" : "ES SysMemoryUtilization"
      "rds_mem_widget" : "RDS FreeableMemory"
      "rds_cpu_widget" : "RDS CPUUtilization"
      "elasti_cache_cpu_widget" : "ElastiCache CPUUtilization"
      "elasti_cache_mem_widget" : "ElastiCache FreeableMemory"
      "elasti_cache_misses_hits_widget" : "ElastiCache Cache Hits-Misses"
      "elasti_cache_curritemsv_widget" : "ElastiCache CurrItems"
    }
    "widget_height" = {
      "http_responses_widget" : "6"
    }
    "widget_width" = {
      "http_responses_widget" : "12"
      "http_response_time_widget" : "12"
      "ecs_services_mem_widget" : "12"
      "ecs_services_cpu_widget" : "12"
      "elasti_cache_curritemsv_widget" : "6"
    }
  }

  rds = {
    widget_title = {
      rds_r_w_latency_widget : "RDS Read-WriteLatency"
      rds_r_w_iops_widget : "RDS Read-WriteIOPS"
      rds_mem_widget : "RDS FreeableMemory"
      rds_cpu_widget : "RDS CPUUtilization"
    }
    widget_height = {
      rds_r_w_latency_widget = 6
      rds_r_w_iops_widget    = 6
      rds_cpu_widget         = 6
      rds_mem_widget         = 6
    }
    widget_width = {
      rds_r_w_latency_widget = 12
      rds_r_w_iops_widget    = 12
      rds_cpu_widget         = 12
      rds_mem_widget         = 12
    }
  }

  redis = {
    "widget_title" = {
      "elasti_cache_cpu_widget" : "ElastiCache CPUUtilization"
      "elasti_cache_mem_widget" : "ElastiCache FreeableMemory"
      "elasti_cache_misses_hits_widget" : "ElastiCache Cache Hits-Misses"
      "elasti_cache_curritemsv_widget" : "ElastiCache CurrItems"
    }
    "widget_height" = {
      "elasti_cache_curritemsv_widget" : "6"
    }
    "widget_width" = {
      "elasti_cache_curritemsv_widget" : "6 "
    }
  }

}
