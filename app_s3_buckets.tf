module "s3_bucket_logs" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = true
  bucket        = "logs-${var.private_s3_logs_bucket_name}-${var.app_environment}"
  acl           = var.private_s3_logs_bucket_acl
  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  force_destroy           = true
  versioning = {
    enabled = var.private_s3_logs_bucket_versioning
  }
  grant = [{
    id         = data.aws_canonical_user_id.current_user.id
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
  }]
}

module "s3_bucket_public" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = true
  bucket        = "${var.public_s3_bucket_name}-${var.app_environment}-pub"
  acl           = var.public_s3_bucket_acl
  attach_policy = true
  #policy        = file("./s3_public_bucket_policy.json")
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "Policy1631456399958",
    "Statement" : [
      {
        "Sid" : "Stmt1631456390388",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:DeleteObject",
          "s3:GetObject"
        ],
        "Resource" : "arn:aws:s3:::${var.public_s3_bucket_name}-${var.app_environment}-pub/*"
      }
    ]
  })
  grant = [{
    id         = data.aws_canonical_user_id.current_user.id
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
  }]
  force_destroy = true
  versioning = {
    enabled = var.public_s3_bucket_versioning
  }
  logging = {
    target_bucket = module.s3_bucket_logs.s3_bucket_id
    target_prefix = "s3_logs/"
  }
}

module "s3_bucket_private" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = true
  bucket        = "${var.private_s3_bucket_name}-${var.app_environment}-prv"
  acl           = var.private_s3_bucket_acl
  attach_policy = false
  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  grant = [{
    id         = data.aws_canonical_user_id.current_user.id
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
  }]

  force_destroy = true
  versioning = {
    enabled = var.private_s3_bucket_versioning
  }
}
