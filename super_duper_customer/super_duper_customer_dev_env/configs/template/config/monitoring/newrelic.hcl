locals {
  secrets = read_terragrunt_config(find_in_parent_folders("secrets/monitoring/newrelic.hcl"))
  newrelic_integration = {
    enable_production_mode = true
    enable_integration     = true
    enable_apm             = true
    license_key            = local.secrets.locals.newrelic_integration.license_key
    insights_key           = local.secrets.locals.newrelic_integration.insights_key
    api_key                = local.secrets.locals.newrelic_integration.api_key
    account_id             = local.secrets.locals.newrelic_integration.account_id
    opsgenie_api_key       = local.secrets.locals.newrelic_integration.opsgenie_api_key
    newrelic_account_type  = "client"
  }

  aws_integration = {
    enabled                 = true
    role_name               = local.secrets.locals.aws_integration.role_name
    read_only_policy_arn    = local.secrets.locals.aws_integration.read_only_policy_arn
    newrelic_aws_account_id = local.secrets.locals.aws_integration.newrelic_aws_account_id
  }

  basic_auth = local.secrets.locals.basic_auth

  # currently used only for scheduler
  newrelic_agent_version = "1.18.0"

  opsgenie_teams = ["Spryker Cloud Operations"]

  # List containing yves urls to test, like
  # [ https://www.messe.intersport.de", "https://www.vororder.intersport.de" ]
  synthetics_yves_urls = ["https://CHANGE_ME!!!"]

  # Example
  # enabled = false
  # yves    = ""
  # zed     = "https://cloud:cloud@zed.de.aldi-pltfrm-stage.cloud.spryker.toys/health-check"
  # glue    = "https://glue.de.aldi-pltfrm-stage.cloud.spryker.toys/health-check"    
  synthetics_healthcheck_settings = {
    enabled = false
    yves    = "https://CHANGE_ME!!!"
    zed     = "https://zed.CHANGE_ME!!!/health-check"
    glue    = "https://glue.CHANGE_ME!!!/health-check"
  }

  alerting_settings = {
    healthchecks = {
      enabled = false
    }
    alb_5xx_codes = {
      enabled = false
    }

    # RabbitMQ
    rabbitmq_availability = {
      enabled = false
    }
    rabbitmq_memory_alarm = {
      enabled = false
    }
    rabbitmq_disk_alarm = {
      enabled = false
    }
    rabbitmq_error_queue_grow = {
      enabled = false
    }
    rabbitmq_processing_speed = {
      enabled = false
    }
    rabbitmq_disk_space = {
      enabled = false
    }
    rabbitmq_memory = {
      enabled = false
    }

    # Jenkins
    jenkins_cpu_usage = {
      enabled = false
    }
    jenkins_memory_usage = {
      enabled = false
    }
    jenkins_disk_usage = {
      enabled = false
    }
    jenkins_failed_jobs = {
      enabled = false
    }
    jenkins_no_jobs_completed = {
      enabled = false
    }
    jenkins_dataimport_execution_time = {
      enabled = false
    }
    jenkins_inode_usage = {
      enabled = false
    }

    # RDS
    db_connections = {
      enabled = false
    }
    db_io_burst = {
      enabled = false
    }
    aurora_cpu_usage = {
      enabled = false
    }

    # Redis
    redis_status = {
      enabled = false
    }
    redis_out_of_space = {
      enabled = false
    }
    redis_cache_hit_rate = {
      enabled = false
    }

    # Elasticsearch
    elasticsearch_status_red = {
      enabled = false
    }
    #Ec2 Status check failed
    ec2_statusfailed_red = {
      enabled = false
    }

    #Ec2 CPU Credit Balance
    ec2_cpucredit_balance = {
      enabled = false
    }
  }

  sla_alerting_settings = {
    sl80_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl81_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.99
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.80
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl82_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl83_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl84_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl86_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl87_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    frontend_availability = {
      warning = {
        operator              = "below"
        threshold             = 99.99
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.98
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    }
    backend_availability = {
      warning = {
        operator              = "below"
        threshold             = 99.90
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "All"
      }
    }
    sl88_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    }
    sl89_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    }
    sl90_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    }
    sl91_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.75
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl92_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl93_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl95_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.99
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.00
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl96_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl97_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl98_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl99_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.95
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 99.00
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
    sl59_alerting_settings = {
      warning = {
        operator              = "below"
        threshold             = 99.50
        threshold_duration    = 360
        threshold_occurrences = "at_least_once"
      }
      critical = {
        operator              = "below"
        threshold             = 97.00
        threshold_duration    = 360
        threshold_occurrences = "ALL"
      }
    },
  }

  # ECS SETTINGS
  enable_nri_ecs               = "true"
  nria_override_host_root      = "/host"
  nria_passthrough_environment = "ECS_CONTAINER_METADATA_URI,ENABLE_NRI_ECS"
  nria_verbose                 = "0"

  # RABBITMQ MONITORING PARAMETERS
  rabbitmq_queues_regexes        = "[\".*\"]"
  rabbitmq_exchange_regexes      = "[\".*\"]"
  rabbitmq_integrations_interval = "15"
}
