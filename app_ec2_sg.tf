module "app_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.app_name}-${var.app_ec2_sg_name}-${var.app_environment}-sg"
  description = "Security group for user-service with custom ports open within VPC"
  vpc_id      = module.app_vpc.vpc_id
  #egress_with_cidr_blocks = [{ rule = "all-all", cidr_blocks = "0.0.0.0/0" }]
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP Open to World"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "8080 Open to World"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 587
      to_port     = 587
      protocol    = "tcp"
      description = "587 Open to World"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 2020
      to_port     = 2020
      protocol    = "tcp"
      description = "2020 Open to World"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS Open to World"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "22 Open to VPC"
      cidr_blocks = "10.0.0.0/24"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "22 Open to VPC"
      cidr_blocks = "10.0.1.0/24"
    },
    #  
    #    {
    #      rule        = "postgresql-tcp"
    #      cidr_blocks = "0.0.0.0/0"
    #    },
  ]
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }
}
