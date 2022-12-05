locals {
  secrets                  = read_terragrunt_config(find_in_parent_folders("secrets/common/secrets.hcl"))
  spryker_secrets          = local.secrets.locals.spryker_secrets
  ssm_ansible_password     = local.secrets.locals.ssm_ansible_password
  hashicorp_vault_password = local.secrets.locals.hashicorp_vault_password
  EASYRSA_CERT_EXPIRE      = local.secrets.locals.EASYRSA_CERT_EXPIRE
  vpn_inactivity_timeout   = local.secrets.locals.vpn_inactivity_timeout
}
