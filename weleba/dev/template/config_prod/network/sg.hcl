locals {
  network = read_terragrunt_config(find_in_parent_folders("config/network/vpc.hcl"))
  initial = {
    name = "initial"
    sg_rules = {
      inbound = {
        ssh_spryker_vpn = {
          from_port   = 22
          to_port     = 22
          from_addr   = "3.122.124.183/32"
          protocol    = "tcp"
          description = "SSH from Spryker VPN"
        }
        http_spryker_vpn = {
          from_port   = 80
          to_port     = 80
          from_addr   = "3.122.124.183/32"
          protocol    = "tcp"
          description = "HTTP from Spryker VPN"
        }
        https_spryker_vpn = {
          from_port   = 443
          to_port     = 443
          from_addr   = "3.122.124.183/32"
          protocol    = "tcp"
          description = "HTTPS from Spryker VPN"
        }
        connect_vpn = {
          from_port   = 1194
          to_port     = 1194
          from_addr   = "0.0.0.0/0"
          protocol    = "udp"
          description = "OpenVPN from Internet"
        },
        internal = {
          from_port   = 0
          to_port     = 0
          from_addr   = local.network.locals.vpc_cidr_block
          protocol    = "-1"
          description = "Allow internal connections"
        },
        vpn = {
          from_port   = 0
          to_port     = 0
          from_addr   = "172.31.0.0/16" // test value
          protocol    = "-1"
          description = "Allow all from VPN"
        },
        php = {
          from_port   = 9000
          to_port     = 9003
          from_addr   = local.network.locals.vpc_cidr_block
          protocol    = "tcp"
          description = "Allow all from VPN"
        },
      }
      outbound = {
        all = {
          from_port   = 0
          to_port     = 0
          to_addr     = "0.0.0.0/0"
          protocol    = "-1"
          description = "Allow fastcgi connections from internal network"
        }
      }
    }
  }
  lb = {
    name = "alb-sg"
    sg_rules = {
      inbound = {
        http_all = {
          from_port   = 80
          to_port     = 80
          from_addr   = "0.0.0.0/0"
          protocol    = "tcp"
          description = "HTTP from Internet"
        }
        https_all = {
          from_port   = 443
          to_port     = 443
          from_addr   = "0.0.0.0/0"
          protocol    = "tcp"
          description = "HTTPS from Internet"
        }
      }
      outbound = {
        all = {
          from_port   = 0
          to_port     = 0
          to_addr     = "0.0.0.0/0"
          protocol    = "-1"
          description = "Allow all outbound"
        }
      }
    }
  }
  rds = {
    name = "rds"
    sg_rules = {
      inbound = {
        sql = {
          from_port   = 3306 //hardcode
          to_port     = 3306
          from_addr   = local.network.locals.vpc_cidr_block
          protocol    = "tcp"
          description = "MySQL from local net"
        },
      }
      outbound = {
        all = {
          from_port   = 0
          to_port     = 0
          to_addr     = "0.0.0.0/0"
          protocol    = "-1"
          description = "Allow fastcgi connections from internal network"
        }
      }
    }
  }
  codebuild = {
    name = "codebuild"
    sg_rules = {
      inbound = {
      }
      outbound = {
        all = {
          from_port   = 0
          to_port     = 0
          to_addr     = "0.0.0.0/0"
          protocol    = "-1"
          description = "Allow all outbound traffic"
        }
      }
    }
  }
  efs = {
    name = "efs"
    sg_rules = {
      inbound = {
        http_all = {
          from_port   = 2049
          to_port     = 2049
          from_addr   = local.network.locals.vpc_cidr_block
          protocol    = "tcp"
          description = "EFS from internal"
        }
      }
      outbound = {
        all = {
          from_port   = 0
          to_port     = 0
          to_addr     = "0.0.0.0/0"
          protocol    = "-1"
          description = "Allow all outbound traffic"
        }
      }
    }
  }
  redis = {
    name = "redis"
    sg_rules = {
      outbound = {
      }
      inbound = {
        redis = {
          from_port   = 6379
          to_port     = 6379
          from_addr   = local.network.locals.vpc_cidr_block
          protocol    = "tcp"
          description = "Connect Spryker apps to redis"
        }
      }
    }
  }
}
