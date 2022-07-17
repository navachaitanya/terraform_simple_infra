resource "aws_acm_certificate" "alb_test_cert" {
  private_key      = file("./ssl/85419186_localhost.key")
  certificate_body = file("./ssl/85419186_localhost.cert")
  #certificate_chain = file("./CA.cer")
  tags = { Name = "alb_test_cert" }
}
