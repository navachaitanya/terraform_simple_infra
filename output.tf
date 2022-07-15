output "app_ec2_instance" {
  #value = module.app_ec2_instance["one"].id
  value = module.app_ec2_instance.id
}
output "test_acm_certificate" {
  #value = module.app_ec2_instance["one"].id
  value     = aws_acm_certificate.test_cert
  sensitive = true
}
