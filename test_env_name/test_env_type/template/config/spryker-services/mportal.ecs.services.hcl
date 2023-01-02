locals {
  service_name                       = "mportal"
  network_mode                       = "test3"
  cpu_limit                          = 1111
  memory_limit                       = 1111
  volumes                            = {}
  scheduling_strategy                = "test3"
  desired_count                      = 33
  health_check_grace_period_seconds  = 333
  deployment_maximum_percent         = 333
  deployment_minimum_healthy_percent = 333
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 333
  autoscaling_max_capacity           = 333
  load_balancer_type                 = "internal"
  deregistration_delay               = 333
  logs_expire                        = 333
  listener_mappings = {
    fpm = {
      lb_protocol        = "TCP"
      lb_port            = 9004
      container_protocol = "TCP"
      container_port     = 9000
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name        = "mportal"
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