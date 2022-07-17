output "app_ec2_instance" {
  #value = module.app_ec2_instance["one"].id
  value = module.app_ec2_instance.id
}
output "test_acm_certificate" {
  #value = module.app_ec2_instance["one"].id
  value     = aws_acm_certificate.alb_test_cert
  sensitive = true
}
output "app_alb_dns_name" {
  #value = module.app_ec2_instance["one"].id
  value     = module.alb.lb_dns_name
  sensitive = false
}
output "app_alb_id" {
  #value = module.app_ec2_instance["one"].id
  value     = module.alb.lb_id
  sensitive = false
}
output "rds_instance_url" {
  #value = module.app_ec2_instance["one"].id
  value     = module.app_rds_postgresql.db_instance_address
  sensitive = false
}
output "s3_bucket_logs_name" {
  #value = module.app_ec2_instance["one"].id
  value     = module.s3_bucket_logs.s3_bucket_id
  sensitive = false
}
output "s3_bucket_public_name" {
  #value = module.app_ec2_instance["one"].id
  value     = module.s3_bucket_public.s3_bucket_id
  sensitive = false
}
output "s3_bucket_private_name" {
  #value = module.app_ec2_instance["one"].id
  value     = module.s3_bucket_private.s3_bucket_id
  sensitive = false
}

