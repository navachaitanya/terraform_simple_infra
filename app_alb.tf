module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 6.0"
  name               = "${var.app_loadbalancer_name}-alb-${var.app_environment}"
  create_lb          = true
  load_balancer_type = var.appload_balancer_type
  internal           = var.app_load_balancer_scheme_type
  vpc_id             = module.app_vpc.vpc_id
  subnets            = module.app_vpc.public_subnets
  security_groups    = [module.app_alb_sg.security_group_id]
  # access_logs = {
  #   bucket = "my-alb-logs"
  # }
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "${aws_acm_certificate.alb_test_cert.arn}"
      target_group_index = 0
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  target_groups = [
    {
      name_prefix          = local.app_eks_target_groups_name
      backend_protocol     = "HTTPS"
      backend_port         = 443
      target_type          = "instance"
      deregistration_delay = 10
      stickiness = {
        cookie_duration : 3600
        enabled : false
        type : "lb_cookie"
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTPS"
        matcher             = "200"
      }
      protocol_version = "HTTP1"
      targets = [
        {
          target_id = module.app_ec2_instance.id
          port      = 443
        }
      ]
      tags = {
        InstanceTargetGroupTag = "app"
      }
    },
  ]
  tags = {
    vpc_name    = "${var.app_vpc_name}"
    app_name    = "${var.app_name}"
    Environment = "${var.app_environment}"
    Terraform   = "true"
  }
  depends_on = [
    module.app_vpc,
    module.app_ec2_instance.id
  ]

}
