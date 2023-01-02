locals {
  vpc_cidr_block  = "10.106.0.0/16"
  vpc_enable_ipv6 = false
  secondary_cidr  = false
  public_nets = [
    "10.106.1.0/24",
    "10.106.2.0/24"
  ]
  private_cmz_subnets = [
    "10.106.4.0/24",
    "10.106.5.0/24"
  ]
  private_middle_subnets = [
    "10.106.6.0/24",
    "10.106.7.0/24"
  ]
  private_dmz_subnets = [
    "10.106.8.0/24",
    "10.106.9.0/24"
  ]
  enable_vpc_peering_to_vpn = false
  nat_redundancy            = false
}
