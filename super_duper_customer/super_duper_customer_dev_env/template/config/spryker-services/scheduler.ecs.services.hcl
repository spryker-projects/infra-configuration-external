locals {
  service_name       = "jenkins" # Previous "jenkins" shorted for avoid aws_lb_target_group.name max 32 charachter in _lb_target_group_single (maybe a check in module must be introduced)
  network_mode       = "awsvpc"
  cpu_limit          = 512
  memory_limit       = 2048
  efs_root_directory = "/"
  volumes = {
    jenkins-media = {
      type         = "efs"
      target       = "/media/jenkins"
      efs_root_dir = "/"
    }
  }
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  health_check_grace_period_seconds  = 15
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 0
  autoscaling_max_capacity           = 0
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  logs_expire                        = 60
  listener_mappings = {
    jks = {
      lb_protocol        = "TCP"
      lb_port            = 80
      container_protocol = "TCP"
      container_port     = 8080
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name  = "jenkins"
    image = null
    mountPoints = [
      {
        containerPath = "/root/.jenkins"
        sourceVolume  = "jenkins_root"
      }
    ]
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }
    ]
  }
}