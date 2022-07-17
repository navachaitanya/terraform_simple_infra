module "app_ec2_instance" {
  source                               = "terraform-aws-modules/ec2-instance/aws"
  create                               = true
  version                              = "~> 3.0"
  name                                 = "${var.app_instance_name}-${var.app_environment}"
  ami                                  = data.aws_ami.amazon_linux_2.id
  instance_type                        = var.app_instance_type
  key_name                             = module.ec2_key_pair.key_pair_key_name
  monitoring                           = var.app_ec2_monitoring
  vpc_security_group_ids               = [module.app_sg.security_group_id]
  subnet_id                            = module.app_vpc.public_subnets[1]
  instance_initiated_shutdown_behavior = "stop"
  disable_api_termination              = false
  tenancy                              = "default"
  user_data_base64                     = local.ec2_userdata_scripts
  iam_instance_profile                 = aws_iam_instance_profile.ec2_s3_access_profile.name
  root_block_device = [
    {
      volume_type = "${var.app_ec2_root_block_device_volume_type}"
      volume_size = "${var.app_ec2_root_block_device_volume_size}"
      encrypted   = true
    },
  ]
  #Tags
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }

}
#ssh keypair for the EC2
module "ec2_key_pair" {
  source          = "terraform-aws-modules/key-pair/aws"
  create_key_pair = true
  key_name        = "${var.app_name}-${var.app_environment}-ec2-keypair"
  public_key      = var.ec2_ssh_public_key
  tags = {
    Name        = "${var.app_name}-ec2-keypair"
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
    Created_Key_from_External = "yes"
  }
  depends_on = [
    module.app_vpc,
    aws_iam_role.ec2_s3_access_role,
    aws_iam_instance_profile.ec2_s3_access_profile,
    aws_iam_role_policy.ec2_s3_access_policy
  ]
}
