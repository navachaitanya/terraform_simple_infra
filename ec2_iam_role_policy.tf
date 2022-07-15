resource "aws_iam_role_policy" "ec2_s3_access_policy" {
  name   = "ec2_s3_access_policy"
  role   = aws_iam_role.ec2_s3_access_role.id
  policy = file("resources/policies/ec2_s3_access_policy.json")
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "ec2_s3_access_role"
  description        = "IAM role for the EC2 instance for s3 access"
  assume_role_policy = file("resources/policies/ec2_s3_access_role.json")
}
resource "aws_iam_instance_profile" "ec2_s3_access_profile" {
  name = "ec2_s3_access_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}
