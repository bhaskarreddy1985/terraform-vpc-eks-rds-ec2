# Output credentials
output "aws_access_key_id" {
  value       = aws_iam_access_key.s3_user_keys.id
  sensitive   = true
}

output "aws_secret_access_key" {
  value       = aws_iam_access_key.s3_user_keys.secret
  sensitive   = true
}
output "iam_user_name" {
  value = aws_iam_user.s3_user.name
  
}
output "name_iam_user" {
  value = aws_iam_user.s3_user.name
  
}