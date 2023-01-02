locals {
  service_name                       = "frontend"
  network_mode                       = "awsvpc"
  cpu_limit                          = 512
  memory_limit                       = 512
  volumes                            = {}
  scheduling_strategy                = "REPLICA"
  desired_count                      = 2
  health_check_grace_period_seconds  = 15
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 1
  load_balancer_type                 = external"
  deregistration_delay               = 10
  logs_expire                        = 60
  listener_mappings = {
    http = {
      lb_protocol        = "HTTP"
      lb_port            = 80
      container_protocol = null
      container_port     = null
      ssl_policy         = null
      action             = "redirect_https"
    }
    https = {
      lb_protocol        = "HTTPS"
      lb_port            = 443
      ssl_policy         = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
      container_port     = 80
      container_protocol = "HTTP"
      action             = "forward"
    }
  }
  container_definition = {
    name        = "frontend"
    image       = null
    mountPoints = []
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      },
      {
        containerPort = 443
        hostPort      = 443
        protocol      = "tcp"
      }
    ]
  }
}