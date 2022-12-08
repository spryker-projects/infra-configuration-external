locals {
    docker_image_tag                         = "0.0.1"
    forward_rule_schedule_expression         = "cron(0/10 08-13 ? * * *)"
    lambda_spryker_enabled_features_endpoint = "<template:change-me>"
    create_retro_rule                        = false
    lambda_timeout                           = "300"
}
