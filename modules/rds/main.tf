

data "aws_availability_zones" "available" {
  state = "available"
}


# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.rds_db_name}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.rds_db_name}-sg-a2"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.rds_db_name}-subnet-group-a2"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.rds_db_name}-subnet-group"
  }
}

# Generate a random password
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#%&()*+-.:;<=>?[]^_{|}~"
}

# Generate a random name for the secret
resource "random_pet" "secret_name" {
  length    = 2
  separator = "-"
}

# Store password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "${var.rds_db_name}-${random_pet.secret_name.id}-password"
}


resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id    = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = (var.rds_engine == "aurora" || var.rds_engine == "postgres") ? "postgres" : "admin",
    password = random_password.rds_password.result
  })
}


# MySQL RDS Instance
resource "aws_db_instance" "rds_instance" {
  count                 = var.rds_engine == "mysql" ? 1 : 0
  identifier            = var.rds_db_name
  engine                = var.rds_engine
  instance_class        = var.rds_instance_type
  allocated_storage     = var.rds_storage
  db_name               = replace(var.rds_db_name, "/[^a-zA-Z0-9]/", "")
  username              = "admin"
  password              = random_password.rds_password.result
  snapshot_identifier   = var.rds_snapshot_id != "" ? var.rds_snapshot_id : null
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot = true
  availability_zone     = data.aws_availability_zones.available.names[0]
  publicly_accessible   = false
  tags = {
    Name = var.rds_db_name
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres_instance" {
  count                 = var.rds_engine == "postgres" ? 1 : 0
  identifier            = var.rds_db_name
  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  instance_class        = var.rds_instance_type
  allocated_storage     = var.rds_storage
  db_name               = replace(var.rds_db_name, "/[^a-zA-Z0-9]/", "")
  username              = "postgres"
  password              = random_password.rds_password.result
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot   = true
  availability_zone     = data.aws_availability_zones.available.names[0]

  publicly_accessible = false
  tags = {
    Name = "${var.rds_db_name}-postgres"
  }
}


# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  count                  = var.rds_engine == "aurora" ? 1 : 0
  cluster_identifier     = "${var.rds_db_name}-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = var.rds_engine_version
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  backup_retention_period = 7
  skip_final_snapshot    = true
  database_name   = var.rds_snapshot_id == "" ? replace(var.rds_db_name, "/[^a-zA-Z0-9]/", "") : null
  master_username = "postgres"
  master_password = random_password.rds_password.result
  snapshot_identifier = var.rds_snapshot_id != "" ? var.rds_snapshot_id : null

  tags = {
    Name        = "${var.rds_db_name}-aurora"
    Environment = var.environment
  }
}

# Aurora PostgreSQL Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  count                = var.rds_engine == "aurora" ? 1 : 0
  identifier           = "${var.rds_db_name}-aurora-instance"
  cluster_identifier   = aws_rds_cluster.aurora_cluster[0].id
  instance_class       = var.rds_instance_type
  engine               = "aurora-postgresql"
  publicly_accessible  = false
  availability_zone    = data.aws_availability_zones.available.names[0]
}
