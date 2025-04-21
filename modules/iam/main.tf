# IAM Policy Document (inline or from external file)
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.s3_bucket_name}-policy"
  description = "Allow specific S3 access to broker-saas bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::${var.s3_bucket_name}",
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

# IAM User
resource "aws_iam_user" "s3_user" {
  name = var.iam_user_name
}

# IAM Policy Attachment
resource "aws_iam_user_policy_attachment" "s3_user_attach" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# IAM Access Keys (programmatic access)
resource "aws_iam_access_key" "s3_user_keys" {
  user = aws_iam_user.s3_user.name
}

resource "local_file" "s3_user_keys_output" {
  content = jsonencode({
    access_key_id     = aws_iam_access_key.s3_user_keys.id
    secret_access_key = aws_iam_access_key.s3_user_keys.secret
  })
  filename = "${path.module}/s3_user_keys.json"
}
