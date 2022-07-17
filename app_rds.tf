module "app_rds_postgresql" {
  source                              = "terraform-aws-modules/rds/aws"
  create_db_instance                  = false
  version                             = "4.5.0"
  engine                              = var.rds_engine
  engine_version                      = var.rds_engine_version
  family                              = var.rds_family
  major_engine_version                = "13.4"
  instance_class                      = var.rds_identifier_instance_type
  allocated_storage                   = var.rds_storage_size
  max_allocated_storage               = var.rds_storage_size_max
  storage_encrypted                   = false
  identifier                          = var.rds_identifier_name
  db_name                             = var.rds_name
  username                            = var.rds_username
  password                            = var.rds_password
  port                                = "5432"
  multi_az                            = var.rds_multi_az
  iam_database_authentication_enabled = false
  vpc_security_group_ids              = [module.app_rds_sg.security_group_id]
  maintenance_window                  = "Mon:00:00-Mon:03:00"
  backup_window                       = "03:00-06:00"
  subnet_ids                          = module.app_vpc.database_subnets
  deletion_protection                 = false
  publicly_accessible                 = false
  #monitoring_interval                 = "30"
  #monitoring_role_name                = "MyRDSMonitoringRole"
  create_monitoring_role    = false
  create_db_subnet_group    = true
  db_subnet_group_name      = var.rds_db_subnet_group_name
  create_db_parameter_group = true
  parameter_group_name      = var.rds_parameter_group_name
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }
  parameters = [
    {
      name  = "autovacuum"
      value = "1"
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  depends_on = [
    module.app_vpc
  ]
}
