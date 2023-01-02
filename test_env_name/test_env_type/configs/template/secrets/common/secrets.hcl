locals {
  spryker_secrets = {
    SPRYKER_OAUTH_KEY_PRIVATE        = "<template:change_me>"
    SPRYKER_OAUTH_KEY_PUBLIC         = "<template:change_me>"
    SPRYKER_OAUTH_ENCRYPTION_KEY     = "<template:change_me>"
    SPRYKER_OAUTH_CLIENT_IDENTIFIER  = "<template:change_me>"
    SPRYKER_OAUTH_CLIENT_SECRET      = "<template:change_me>"
    SPRYKER_ZED_REQUEST_TOKEN        = "<template:change_me>"
    SPRYKER_URI_SIGNER_SECRET_KEY    = "<template:change_me>"
    SPRYKER_PAAS_SERVICES            = "<template:change_me>"
    SPRYKER_FEATURES                 = "<template:change_me>"
    SPRYKER_MAINTENANCE_MODE_ENABLED = "<template:change_me>"
  }
  ssm_ansible_password     = "<template:change_me>"
  hashicorp_vault_password = "<template:change_me>"
  vpn_inactivity_timeout   = "<template:change_me>"
  EASYRSA_CERT_EXPIRE      = "<template:change_me>"
}
