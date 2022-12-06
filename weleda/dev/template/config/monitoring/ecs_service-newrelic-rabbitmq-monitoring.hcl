locals {
  service_name = "newrelic-rabbitmq-monitoring"
  network_mode = "bridge"
  pid_mode     = "host"
  cpu_limit    = 200
  memory_limit = 384
  volumes = {
    host_root_fs = {
      type         = "hostPath"
      target       = "/"
      efs_root_dir = null
    }
    docker_sock = {
      type         = "hostPath"
      target       = "/var/run/docker.sock"
      efs_root_dir = null
    }
  }
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 1
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  listener_mappings                  = {}
  container_definition = {
    name  = "newrelic-rabbitmq-monitoring"
    image = "spryker/newrelic-rabbitmq-agent:4"
    mountPoints = [
      {
        readOnly      = true,
        containerPath = "/var/run/docker.sock",
        sourceVolume  = "docker_sock"
      },
      {
        readOnly      = true,
        containerPath = "/host",
        sourceVolume  = "host_root_fs"
      }
    ]
    portMappings = [
      {
        containerPort = 8125
        hostPort      = 8125
        protocol      = "tcp"
      }
    ]
  }
}
