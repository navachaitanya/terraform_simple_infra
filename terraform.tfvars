#################### TERRAFORM SCRIPT REQUIRED VARIABLES FOR INFRA SETUP #####################
app_name = "terraform" # Application Name, ex: test
#################### VPC - Required Variables ################################################
vpc_region             = "ap-south-1"                                        # VPC Region, ex: ap-south-1
app_vpc_name           = "terraform-vpc"                                        # VPC Name ex: test-vpc
app_vpc_cidr_block     = "172.26.0.0/16"                                     # VPC CIDR BLOCK, ex: "172.26.0.0/16"
app_availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]       # VPC Subnets availability Zones ex: "ap-south-1a", "ap-south-1b", "ap-south-1c"
app_public_subnets     = ["172.26.1.0/24", "172.26.2.0/24", "172.26.3.0/24"] # VPC Public Subnets IPv4 CIDR block for   #of regions provided in availability, ex: "172.26.1.0/24", "172.26.2.0/24", "172.26.3.0/24"
app_private_subnets    = ["172.26.4.0/24", "172.26.5.0/24", "172.26.6.0/24"] # VPC Private Subnets IPv4 CIDR block for  #of regions provided in availability, ex: "172.26.4.0/24", "172.26.5.0/24", "172.26.6.0/24"
app_db_subnets         = ["172.26.7.0/24", "172.26.8.0/24", "172.26.9.0/24"] # VPC Database Subnets IPv4 CIDR block for #of regions provided in availability, ex: "172.26.7.0/24", "172.26.8.0/24", "172.26.9.0/24"
####################### EC2 ASG and EC2 Security Group - Required Variables ##################
app_environment                       = "dev"      # Type of Application environment, ex: dev, qa, prod
app_instance_name                     = "terraform"   # EC2 - App Name or EC2 Name, This will the EC2 Instance Name, ex: test
app_instance_type                     = "t3.small" # EC2 - Instance Type, ex: "t3.small"
app_ec2_sg_name                       = "ec2-sg"   # EC2 - Security Group Name, ex: test-sg, use only '-' between words
app_ec2_monitoring                    = true       # EC2 - Enable Monitoring for EC2 Instance "true" or "false"
app_ec2_root_block_device_volume_type = "gp2"      # EC2 - Root volume type, ex: "gp2"
app_ec2_root_block_device_volume_size = "30"       # EC2 - Root volume size, ex: "30"

####################### ALB and ALB Security Group - Required Variables ######################
app_loadbalancer_name         = "terraform-lb"   # ALB - App Loadbalancer name, ex: test-lb
appload_balancer_type         = "application" # ALB - Application Load Balancer Type
app_alb_sg_name               = "alb_sg"      # ALB - App Application Load Balancer security Group Name, ex: test_sg
app_load_balancer_scheme_type = false         # ALB - Application Load Balancer type, Internal or External, set to false
####################### RDS and RDS Security Group  - Required Variables #####################
rds_name                     = "devrdsterraform"            # RDS - DATABASE NAME - rds identifier name and rds name - should be Letters and Numbers and NO UNDERSCORES
rds_identifier_name          = "devrdsterraform"            # RDS - Identifier name and rds name - should be Letters and Numbers and NO UNDERSCORES and NO hyphens
rds_identifier_instance_type = "db.t3.micro"             # RDS - Instance Type
rds_storage_size             = 20                        # RDS - Storage Size
rds_storage_size_max         = 100                       # RDS - Max storage allocation size
rds_username                 = "terraformappusr"            # RDS - Username - should be ne Letters and Numbers and NO UNDERSCORES
rds_password                 = "terraform!123"              # RDS - Password change this as per requirement
rds_sg_name                  = "rds-sg"                  # RDS - Security Group Name, ex: test-sg, use only '-' between words
rds_multi_az                 = false                     # RDS - Set this value to tue only if multi availability zone should be enabled
rds_db_subnet_group_name     = "app-rds-db-subnet-group" # RDS DB Subnet group name - should be ne Letters, Numbers, hyphens only
rds_parameter_group_name     = "app-rds-pg-group"        # RDS Parameter group name - should be ne Letters and Numbers and hyphens only
rds_family                   = "postgres13"              # RDS family, set this to  postgres13 for PostgreSQL
rds_engine                   = "postgres"                # RDS engine, set this to postgres for PostgreSQL
rds_engine_version           = "13.3"                    # RDS engine version, set this to 13.3 for PostgreSQL version 13.3
####################### S3 Bucket - Required Variables #######################################
##### PUBLIC S3 Bucket #######
public_s3_bucket_name = "terraform-app" # S3 - Bucket Name Should be ne Letters, Numbers, hyphens only and NO UNDERSCORES
#public_s3_bucket_acl = "public-read"     # S3
public_s3_bucket_acl = "null" # S3
#public_s3_bucket_acl = "private"         # S3
public_s3_bucket_versioning = true # S3 - Bucket Versioning, ex: true or false
##############################
##### PRIVATE S3 Bucket ######
private_s3_bucket_name = "terraform-app" # S3 - Bucket Name Should be ne Letters, Numbers, hyphens only and NO UNDERSCORES
#public_s3_bucket_acl = "public-read"         # S3
private_s3_bucket_acl = "null"         # S3
#public_s3_bucket_acl = "private"         # S3
private_s3_bucket_versioning = true # S3 - Bucket Versioning, ex: true or false
##############################
###### LOGS S3 Bucket ########
private_s3_logs_bucket_name = "terraform-app-logs" # S3 - Bucket Name Should be ne Letters, Numbers, hyphens only and NO UNDERSCORES
#private_s3_logs_bucket_acl = "private"         # S3
private_s3_logs_bucket_acl        = "null"         # S3
private_s3_logs_bucket_versioning = true # S3 - Bucket Versioning, ex: true or false
##############################
####################### EC2 - KEYPAIR - Required Variables ###################################
#SSH Public Key for EC2 Instances
ec2_ssh_public_key = " "
#####