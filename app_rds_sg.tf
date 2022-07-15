module "app_rds_sg" {
  source       = "terraform-aws-modules/security-group/aws"
  name         = "${var.app_name}-${var.rds_sg_name}-${var.app_environment}-sg"
  description  = "Security group for user-service with custom ports open within VPC"
  vpc_id       = module.app_vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }
}
