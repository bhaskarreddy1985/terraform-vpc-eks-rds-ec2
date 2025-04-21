terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.91.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  # profile = "DevOpsPermissionSet"
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  cidr_block  = var.cidr_range
  environment = var.environment
  aws_region  = var.aws_region
}

module "ec2" {
  source        = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnets[0] # Selecting AZ 1a
  instance_type = var.instance_type
  ami_type      = var.ami_type
  storage_size  = var.storage_size
  allowed_ports = var.allowed_ports
  environment   = var.environment
  git_username  = var.git_username
  git_password  = var.git_password
  domain_name   = var.domain_name
  # key_name      = var.key_name
}

# module "rds" {
#   source              = "./modules/rds"
#   rds_db_name         = var.rds_db_name
#   rds_engine          = var.rds_engine
#   rds_instance_type   = var.rds_instance_type
#   rds_engine_version  = var.rds_engine_version
#   rds_snapshot_id     = var.rds_snapshot_id
#   vpc_id              = module.vpc.vpc_id
#   subnet_ids          = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
#   allowed_cidr_blocks = ["10.0.0.0/16"]
#   environment         = var.environment
#   rds_storage = var.rds_storage
#   rds_max_allocated_storage = var.rds_max_allocated_storage
# }

module "eks" {
  source         = "./modules/eks"
  eks_cluster_name   = var.eks_cluster_name
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets
  instance_type  = var.node_instance_type
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
  environment    = var.environment
}

#S3 Module (Creates Bucket)
module "s3" {
  source        = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
  environment = var.environment
}

#IAM Module
module "iam" {
  source         = "./modules/iam"
  s3_bucket_name    = var.s3_bucket_name         # Pass actual bucket name
  iam_user_name  = "${var.domain_name}-s3-user"
}


