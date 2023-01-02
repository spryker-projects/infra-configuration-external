locals {
  secrets       = read_terragrunt_config(find_in_parent_folders("secrets/network/bastion.hcl"))
  instance_name = "bastion"
  settings = {
    size                       = "t3a.micro"
    ebs_size                   = 10
    ebs_iops                   = 0
    ebs_type                   = "gp3"
    ebs_block_device_encrypted = false
  }
  vpn_cidr                                = "10.8.0.0/24"
  sftp_enable                             = true
  custom_sftp_user                        = local.secrets.locals.custom_sftp_user
  efs_infrequent_access_transition_policy = "AFTER_90_DAYS"
}
