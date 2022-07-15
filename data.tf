#AMI for EC2
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name = "name"
#     values = [
#       "amzn-ami-hvm-*-x86_64-gp2",
#     ]
#   }
#   filter {
#     name = "owner-alias"
#     values = [
#       "amazon",
#     ]
#   }
# }
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
data "aws_canonical_user_id" "current_user" {}


# data "aws_route_tables" "aws_vpc_subnets_list" {
#   vpc_id = module.app_vpc.vpc_id
#   aws_vpc_subnets_list =  
# }
