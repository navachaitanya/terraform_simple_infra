module "app_vpc" {
  source                     = "terraform-aws-modules/vpc/aws"
  create_vpc                 = true
  name                       = "${var.app_vpc_name}-${var.app_environment}"
  cidr                       = var.app_vpc_cidr_block
  azs                        = var.app_availability_zones
  public_subnets             = var.app_public_subnets
  private_subnets            = var.app_private_subnets
  database_subnets           = var.app_db_subnets
  instance_tenancy           = "default"
  enable_dns_hostnames       = true
  enable_dns_support         = true
  enable_dhcp_options        = true
  enable_ipv6                = false
  manage_default_route_table = false
  #manage_default_network_acl   = true
  public_dedicated_network_acl  = false
  private_dedicated_network_acl = false
  create_database_subnet_group  = false
  create_igw                    = true
  database_subnet_group_name    = var.rds_db_subnet_group_name
  ##
  public_route_table_tags = {
    Name = "${var.app_vpc_name}-rtb-${var.app_environment}-public"
    Role = "public-routetable"
    Type = "public"
  }
  database_route_table_tags = {
    Name = "${var.app_vpc_name}-rtb-${var.app_environment}-db"
    Role = "db-routetable"
    Type = "private"
  }

  igw_tags = {
    Name = "${var.app_name}-vpc-${var.app_environment}-igw"
    Type = "Internet Gateway"
  }
  ##
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }
}
