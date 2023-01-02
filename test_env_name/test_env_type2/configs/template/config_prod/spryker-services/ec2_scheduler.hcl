locals {
  secrets       = read_terragrunt_config(find_in_parent_folders("secrets/spryker-services/scheduler.hcl"))
  instance_name = "scheduler"
  settings = {
    size                        = "t3.medium"
    ebs_size                    = 50
    ebs_iops                    = 0
    ebs_type                    = "gp2"
    ebs_block_device_encrypted  = false
    root_block_type             = "gp2"
    root_block_size             = 10
    root_block_device_encrypted = false
  }
  sftp_enable          = false
  sftp_efs_mount_point = "/media/sftp-efs"
  opsgenie_api_key     = local.secrets.locals.opsgenie_jenkins_failure_notifications_api_key
  alarm_configuration = {
    alarm_name          = "jenkins-failure-alarm"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = "1"
    metric_name         = "HealthyHostCount"
    namespace           = "AWS/NetworkELB"
    period              = "60"
    statistic           = "Minimum"
    threshold           = 1.0
    alarm_description   = "Number of healthy nodes in Target Group"
    actions_enabled     = "true"
  }
}
