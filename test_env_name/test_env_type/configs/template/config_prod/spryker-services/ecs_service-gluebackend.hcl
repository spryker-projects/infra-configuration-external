locals {
  service_name                       = "gluebackend"
  network_mode                       = "awsvpc"
  cpu_limit                          = 1000
  memory_limit                       = 2000
  volumes                            = {}
  scheduling_strategy                = "REPLICA"
  desired_count                      = 2
  health_check_grace_period_seconds  = 60
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
  autoscaling_enabled                = true
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 2
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  logs_expire                        = 60
  listener_mappings = {
    fpm = {
      lb_protocol        = "TCP"
      lb_port            = 9011
      container_protocol = "TCP"
      container_port     = 9000
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name        = "gluebackend"
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
