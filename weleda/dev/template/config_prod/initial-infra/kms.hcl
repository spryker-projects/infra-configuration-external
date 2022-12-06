locals {
  # 00-initial-infra/01-kms/01-rds/terragrunt.hcl
  rds = {
    key_description = "Key for RDS"
  }
  # 00-initial-infra/01-kms/02-elasticache
  es = {
    key_description = "redis_encryption_key"
  }
}
