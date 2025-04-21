# variable "rds_snapshot_id" {
#   description = "RDS Snapshot ID to restore from (leave empty to create a new instance)"
#   type        = string
  
# }


variable "rds_db_name"{
    description = "Name of the db"
    type = string
}

variable "rds_engine" {
    description = "Type of the db_engine"
    type = string
}
  
variable "rds_instance_type" {
    description = "Type of the db instance"
    type = string
}


variable "vpc_id" {
  description = "VPC ID where RDS should be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for RDS subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access RDS"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "rds_storage" {
  description = "Storage size for RDS instance in GB"
  type        = number
   
}
variable "rds_max_allocated_storage" {
  description = "value of max allocated storage"
  type        = number
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  
}

variable "rds_snapshot_id" {
  description = "RDS Snapshot ID to restore from (leave empty to create a new instance)"
  type        = string
  
}

# variable "private_subnets" {
#   description = "List of private subnet IDs for the RDS instance"
#   type        = list(string)
# }


