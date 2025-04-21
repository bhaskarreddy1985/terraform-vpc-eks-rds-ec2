# Create a single S3 bucket
resource "aws_s3_bucket" "shared_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name        = var.s3_bucket_name
    Environment = var.environment
  }
}

# Allow public access by disabling all block settings
resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket                  = aws_s3_bucket.shared_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable versioning
resource "aws_s3_bucket_versioning" "shared_bucket_versioning" {
  bucket = aws_s3_bucket.shared_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption using AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "shared_bucket_encryption" {
  bucket = aws_s3_bucket.shared_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy to allow public read and conditional write access
resource "aws_s3_bucket_policy" "custom_public_policy" {
  bucket = aws_s3_bucket.shared_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowPublicReadAccess",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.shared_bucket.arn}/*"
      },
      {
        Sid       = "AllowPublicWriteAccess",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.shared_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "public-read"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
}