locals {
  service_name                       = "mportal"
  network_mode                       = "awsvpc"
  cpu_limit                          = 512
  memory_limit                       = 512
  volumes                            = {}
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  health_check_grace_period_seconds  = 60
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  autoscaling_enabled                = true
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 1
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  logs_expire                        = 60
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
