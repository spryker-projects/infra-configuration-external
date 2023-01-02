locals {
  service_name = "newrelic-host-agent"
  network_mode = "bridge"
  cpu_limit    = 256
  memory_limit = 256
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
  scheduling_strategy                = "DAEMON"
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 1
  autoscaling_enabled                = false
  autoscaling_min_capacity           = 1
  autoscaling_max_capacity           = 1
  load_balancer_type                 = "internal"
  deregistration_delay               = 10
  listener_mappings                  = {}
  container_definition = {
    name  = "newrelic-host-agent"
    image = "newrelic/infrastructure-bundle:2.7.4"
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
        containerPort = 80
        hostPort      = 8980
        protocol      = "tcp"
      }
    ]
  }
}
