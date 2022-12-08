locals {
  vpc_cidr_block  = "10.105.0.0/16"
  vpc_enable_ipv6 = false
  secondary_cidr  = false
  public_nets = [
    "10.105.1.0/24",
    "10.105.2.0/24"
  ]
  private_cmz_subnets = [
    "10.105.4.0/24",
    "10.105.5.0/24"
  ]
  private_middle_subnets = [
    "10.105.6.0/24",
    "10.105.7.0/24"
  ]
  private_dmz_subnets = [
    "10.105.8.0/24",
    "10.105.9.0/24"
  ]
  enable_vpc_peering_to_vpn = false
  nat_redundancy            = false
  enable_vpc_endpoint_apigw = false
  enable_vpc_endpoint_s3    = false
}
