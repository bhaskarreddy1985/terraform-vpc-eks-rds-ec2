# modules/ec2/main.tf
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.environment}-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content          = tls_private_key.ec2_key.private_key_pem
  filename         = "${path.module}/ec2-key.pem"
  file_permission  = "0600"
}


resource "aws_instance" "ec2_instance" {
  ami           = var.ami_type
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  # key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.storage_size
  }

  user_data = templatefile("${path.module}/serverinstall.sh.tpl", {
    git_username = var.git_username
    git_password = var.git_password
    domain_name  = var.domain_name
    DOMAIN_NAME  = "${var.domain_name}.realcube.estate"
  })


  tags = {
    Name        = "${var.domain_name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2_instance.id
  domain   = "vpc"

  tags = {
    Name = "ElasticIP-${var.environment}"
  }

  #   lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}


 
