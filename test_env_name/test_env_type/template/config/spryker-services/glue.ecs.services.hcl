locals {
    service_name                       = "glue"
    network_mode                       = "test2"
    cpu_limit                          = 1099
    memory_limit                       = 1099
    volumes                            = {}
    scheduling_strategy                = "test2"
    desired_count                      = 22
    health_check_grace_period_seconds  = 222
    deployment_maximum_percent         = 222
    deployment_minimum_healthy_percent = 222
    autoscaling_enabled                = false
    autoscaling_min_capacity           = 222
    autoscaling_max_capacity           = 222
    load_balancer_type                 = "test2"
    deregistration_delay               = 222
    logs_expire                        = 222
    listener_mappings = {
        fpm = {
          lb_protocol        = "TCP"
          lb_port            = 9003
          container_protocol = "TCP"
          container_port     = 9000
          ssl_policy         = null
          action             = "forward"
        }
    }
    container_definition = {
        name        = "glue"
        image       = null
        mountPoints = []
        portMappings = [
          {
            containerPort = 9000
            hostPort      = 9000
            protocol      = "tcp"
          }
        ]
    }
}