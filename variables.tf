# VPC Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "cidr_range" {
  description = "VPC CIDR block"
  type        = string
}

# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

# variable "public_subnets" {
#   description = "List of public subnets"
#   type        = list(string)
# }

# variable "private_subnets" {
#   description = "List of private subnets"
#   type        = list(string)
# }

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

# EC2 Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_type" {
  description = "AMI type for EC2 instance"
  type        = string
}

variable "storage_size" {
  description = "Storage size for EC2 instance in GB"
  type        = number
}

variable "allowed_ports" {
  description = "List of allowed ports for EC2 security group"
  type        = list(number)
}

# variable "key_name" {
#   description = "Key pair name for EC2 instance"
#   type        = string
  
# }

# RDS Variables
variable "rds_db_name" {
  description = "Database name"
  type        = string
}



variable "rds_engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
}

variable "rds_instance_type" {
  description = "Instance type for RDS"
  type        = string
}

variable "rds_storage" {
  description = "Storage size for RDS instance in GB"
  type        = number
}

variable "rds_max_allocated_storage" {
    description = "Max allocated storage for RDS instance in GB"
    type        = number
  
}

variable "rds_engine_version" {
  description = "Engine version for RDS instance"
  type        = string
}

# variable "rds_snapshot_id" {
#   description = "Snapshot ID for RDS instance (optional)"
#   type        = string
  
# }


#s3 Variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}


variable "git_password" {
  description = "Git Password"
  type        = string
  sensitive   = true
}

variable "git_username" {
  description = "Git Username"
  type        = string
}

variable "domain_name" {
  description = "Please provide the domain name"
  type        = string
}

# variable "iam_user_name" {
#   description = "IAM user name"
#   type        = string
  
# }


# EKS Variables
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}