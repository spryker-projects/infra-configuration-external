locals {
  service_name                       = "yves"
  network_mode                       = "test"
  cpu_limit                          = 1099
  memory_limit                       = 1099
  volumes                            = {}
  scheduling_strategy                = "test"
  desired_count                      = 2
  health_check_grace_period_seconds  = 22
  deployment_maximum_percent         = 22
  deployment_minimum_healthy_percent = 22
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 22
  autoscaling_max_capacity           = 22
  load_balancer_type                 = "test"
  deregistration_delay               = 22
  logs_expire                        = 22
  listener_mappings = {
    fpm = {
      lb_protocol        = "TCP"
      lb_port            = 9001
      container_protocol = "TCP"
      container_port     = 9000
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name        = "yves"
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