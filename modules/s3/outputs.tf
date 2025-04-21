# Output the S3 bucket ARN
output "s3_bucket_arn" {
    description = "value of the S3 bucket ARN"
    value = aws_s3_bucket.shared_bucket.arn
}