locals {
  service_name                       = "blackfire"
  network_mode                       = "bridge"
  cpu_limit                          = 256
  memory_limit                       = 512
  volumes                            = {}
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  health_check_grace_period_seconds  = 15
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
  autoscaling_enabled                = true
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 1
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  logs_expire                        = 60
  listener_mappings = {
    fpm = {
      lb_protocol        = "TCP"
      lb_port            = 8707
      container_protocol = "TCP"
      container_port     = 8707
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name        = "blackfire"
    image       = "blackfire/blackfire:latest"
    mountPoints = []
    portMappings = [
      {
        containerPort = 8707
        hostPort      = 8707
        protocol      = "tcp"
      }
    ]
  }
}
