module "app_alb_sg" {
  source       = "terraform-aws-modules/security-group/aws"
  name         = "${var.app_name}-${var.app_alb_sg_name}-${var.app_environment}"
  description  = "Security group for user-service with custom ports open within VPC"
  vpc_id       = module.app_vpc.vpc_id
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP Open to world from LB"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPs Open to world from LB"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTPS Open to world from LB"
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
