locals {
  # /02-aws-based-infra/lambda/backup-notifier
  backup-notifier = {
    recipient = "devops@spryker.com"
  }
  # /20-aws-based-infra/lambda/certificate-expiration-date
  certificate-expiration-date = {
    recipient      = "devops@spryker.com"
    threshold_days = 30
  }
}
