output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
  
}
output "private_subnets" {
  value = module.vpc.private_subnets
  
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_instance_ip" {
  value = module.ec2.instance_ip
  
}
output "ec2_key_pair_name" {
  value = module.ec2.ec2_key_pair_name
  
}

# output "rds_endpoint" {
#   description = "The endpoint of the RDS instance"
#   value       = module.rds.rds_endpoint
# }

# output "rds_password_secret_arn" {
#   description = "The ARN of the RDS password secret stored in AWS Secrets Manager"
#   value       = module.rds.rds_password_secret_arn
# }

# output "aurora_instance_endpoint" {
#   description = "The endpoint of the Aurora instance"
#   value       = module.rds.aurora_instance_endpoint
# }

# output "rds_secret_name" {
#   description = "The name of the secret in AWS Secrets Manager storing the RDS password"
#   value       = module.rds.rds_secret_name
# }

# output "aurora_secret_name" {
#   description = "The name of the secret in AWS Secrets Manager storing the Aurora password"
#   value       = module.rds.aurora_secret_name
# }

# output "aurora_password_secret_arn" {
#   description = "The ARN of the Aurora password secret stored in AWS Secrets Manager"
#   value       = module.rds.aurora_password_secret_arn
# }



#Output for S3 Bucket ARN
output "s3_bucket_arn" {
  value = module.s3.s3_bucket_arn
}


output "s3_user_access_key_id" {
  value     = module.iam.aws_access_key_id
  sensitive = true
}

output "s3_user_secret_access_key" {
  value     = module.iam.aws_secret_access_key
  sensitive = true
}


output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
  
}