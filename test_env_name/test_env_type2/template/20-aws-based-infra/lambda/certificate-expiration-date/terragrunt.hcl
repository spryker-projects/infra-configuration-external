include {
  path = find_in_parent_folders()
}

locals {
  spryker         = read_terragrunt_config(find_in_parent_folders("config/common/spryker.hcl"))
  aws-based-infra = read_terragrunt_config(find_in_parent_folders("config/aws-based-infra/lambda.hcl"))
}

terraform {
  source = "git@github.com:spryker/tfcloud-modules.git//refactored/lambda/certificate_expiration_date?ref=v7.0.0"
}

dependency "lambda" {
  config_path = find_in_parent_folders("00-initial-infra/iam/lambda")
}

inputs = {
  project_name        = local.spryker.locals.project_name
  route53_zone_domain = local.spryker.locals.route53_zone_domain
  lambda_iam_role_arn = dependency.lambda.outputs.lambda_iam_role_arn
  threshold_days      = local.aws-based-infra.locals.certificate-expiration-date.threshold_days
  recipient           = local.aws-based-infra.locals.certificate-expiration-date.recipient
}
