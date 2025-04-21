# VPC Configuration
aws_region  = "us-east-2" # Update the AWS region
vpc_name    = "vpc-automation" # Update the VPC name
cidr_range    = "10.0.0.0/16" # Update the CIDR range
# vpc_id         = "vpc-05f48e2e098d27953"  #Need to update the VPC id incase you don't want to create new VPC
# public_subnets = ["subnet-008498cd037d0ba86", "subnet-083fadbcf1f96b109", "subnet-048ef282425cca29d"] # Update the public  subnets
# private_subnets = ["subnet-00d50d6c244c3225c", "subnet-00753b620abd8e48f", "subnet-093251ba87228b9dd"] # Update the private subnets
environment = "dev" # Update the environment (dev, uat, prod)

# EC2 Configuration
instance_type = "t3.medium" # Update the instance type
ami_type      = "ami-04f167a56786e4b09" # Update the AMI type
storage_size  = 30 # Update the storage size
allowed_ports = [22, 80, 443, 5432, 3306] # Update the allowed ports
# key_name = "alsakar-ohio" # Update the key pair name



# RDS Configuration
rds_db_name     = "alsaqer-dev-uat-automation" # Update the RDS database name
rds_engine      = "aurora"  # "postgres" or "mysql" or "aurora" # Update the RDS engine type
rds_engine_version = "16.6" # Update the RDS engine version for PostgreSQL or Aurora
rds_instance_type = "db.t3.medium" # Update the RDS instance type
rds_storage = 20 # Update the RDS storage size
rds_max_allocated_storage = 100 # Update the RDS max allocated storage
# rds_snapshot_id = "alsakar-dev-snap-april" # Update the RDS snapshot ID if you want to restore from a snapshot (leave empty to create a new instance)


# EKS Configuration
eks_cluster_name = "my-eks-cluster"
node_instance_type = "t3.medium"
desired_size = 2
min_size     = 1
max_size     = 5

# S3 Configuration

s3_bucket_name = "personal-uat-automation-a5" # Update the S3 bucket name


# IAM Configuration

# iam_user_name = "S3_bucket_access" # Update the S3 bucket name


# git Configuration
git_username = "m.bhaskarreddy" # Update the git username

# domain Configuration
domain_name = "uat-automation" # Update the domain name which you want to use