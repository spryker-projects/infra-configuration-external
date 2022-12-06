locals {
  target_port          = 80
  target_protocol      = "TCP"
  target_type          = "instance"
  deregistration_delay = 10
  scheduler_healthcheck_configuration = {
    protocol            = "HTTP"
    path                = "/metrics/currentUser/healthcheck"
    port                = 80
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  lb_port                = 80
  lb_protocol            = "TCP"
  stickiness_enabled     = true
  health_check_enabled   = true
  is_alb                 = false
  is_scheduler           = true
  listener_rule_priority = 1
}
