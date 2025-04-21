# output "rds_secret_name" {
#   description = "AWS Secrets Manager secret name"
#   value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret[0].name : null
# }

# output "rds_password_secret_arn" {
#   description = "Value of the RDS password secret ARN"
#   value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret[0].arn : null
# }

# output "db_name" {
#   value = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].db_name : null
# }

# output "db_username" {
#   value = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].username : null
# }

# output "db_port" {
#   value = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].port : null
# }

# output "rds_endpoint" {
#   description = "RDS instance endpoint"
#   value = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].endpoint : null
# }

# # New outputs for Aurora cluster
# output "aurora_cluster_endpoint" {
#   description = "Aurora cluster endpoint"
#   value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].endpoint : null
# }

# output "aurora_cluster_read_endpoint" {
#   description = "Aurora cluster read-only endpoint"
#   value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].reader_endpoint : null
# }

# output "aurora_instance_endpoint" {
#   description = "Aurora instance endpoint"
#   value       = length(aws_rds_cluster_instance.aurora_instance) > 0 ? aws_rds_cluster_instance.aurora_instance[0].endpoint : null
# }

# output "aurora_db_name" {
#   description = "Aurora database name"
#   value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].database_name : null
# }

# output "aurora_db_port" {
#   description = "Aurora database port"
#   value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].port : null
# }



#--------------------------------------


# Outputs for RDS instance
output "rds_secret_name" {
  description = "AWS Secrets Manager secret name"
  value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret.name : null
}

output "rds_password_secret_arn" {
  description = "Value of the RDS password secret ARN"
  value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret.arn : null
}

output "db_name" {
  description = "RDS instance database name"
  value       = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].db_name : null
}

output "db_username" {
  description = "RDS instance database username"
  value       = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].username : null
}

output "db_port" {
  description = "RDS instance database port"
  value       = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].port : null
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = length(aws_db_instance.rds_instance) > 0 ? aws_db_instance.rds_instance[0].endpoint : null
}

# Outputs for Aurora cluster
output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].endpoint : null
}

output "aurora_cluster_read_endpoint" {
  description = "Aurora cluster read-only endpoint"
  value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].reader_endpoint : null
}

output "aurora_instance_endpoint" {
  description = "Aurora instance endpoint"
  value       = length(aws_rds_cluster_instance.aurora_instance) > 0 ? aws_rds_cluster_instance.aurora_instance[0].endpoint : null
}


output "aurora_db_name" {
  description = "Aurora database name"
  value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].database_name : null
}

output "aurora_db_port" {
  description = "Aurora database port"
  value       = length(aws_rds_cluster.aurora_cluster) > 0 ? aws_rds_cluster.aurora_cluster[0].port : null
}

# Aurora secret outputs (if defined)

output "aurora_secret_name" {
  description = "Aurora database secret name"
  value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret.name : null
}

output "aurora_password_secret_arn" {
  description = "Aurora password secret ARN"
  value       = var.rds_snapshot_id == "" ? aws_secretsmanager_secret.rds_secret.arn : null
}
