locals {
    service_name                       = "boffice"
    network_mode                       = "test1"
    cpu_limit                          = 2099
    memory_limit                       = 2099
    volumes                            = {}
    scheduling_strategy                = "test1"
    desired_count                      = 21
    health_check_grace_period_seconds  = 221
    deployment_maximum_percent         = 221
    deployment_minimum_healthy_percent = 221
    autoscaling_enabled                = false
    autoscaling_min_capacity           = 221
    autoscaling_max_capacity           = 221
    load_balancer_type                 = "test1"
    deregistration_delay               = 221
    logs_expire                        = 221
    listener_mappings = {
        fpm = {
          lb_protocol        = "TCP"
          lb_port            = 9005
          container_protocol = "TCP"
          container_port     = 9000
          ssl_policy         = null
          action             = "forward"
        }
    }
    container_definition = {
        name        = "boffice"
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