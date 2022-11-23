locals {
  spryker      = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  service_name = "rabbitmq"
  network_mode = "awsvpc"
  cpu_limit    = 1024
  memory_limit = 2048
  volumes = {
    rabbitmq_data = {
      type         = "efs"
      efs_root_dir = "/"
    }
  }
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  health_check_grace_period_seconds  = 15
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  autoscaling_enabled                = true
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 2
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  logs_expire                        = 60
  listener_mappings = {
    http = {
      lb_protocol        = "${local.spryker.locals.broker_protocol}"
      lb_port            = 15672
      container_protocol = "TCP"
      container_port     = 15672
      ssl_policy         = null
      action             = "forward"
    }
    tcp = {
      lb_protocol        = "TCP"
      lb_port            = 5672
      container_protocol = "TCP"
      container_port     = 5672
      ssl_policy         = null
      action             = "forward"
    }
  }
  container_definition = {
    name  = "rabbitmq"
    image = "spryker/rabbitmq:3.7.14"
    mountPoints = [
      {
        containerPath = "/var/lib/rabbitmq/mnesia/rabbitmq@localhost"
        sourceVolume  = "rabbitmq_data"
      }
    ]
    portMappings = [
      {
        containerPort = 15672
        hostPort      = 15672
        protocol      = "tcp"
      },
      {
        containerPort = 5672
        hostPort      = 5672
        protocol      = "tcp"
      }
    ]
  }
}