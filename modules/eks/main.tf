resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.eks_cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  count      = length(var.eks_cluster_policies)
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = var.eks_cluster_policies[count.index]
}

resource "aws_security_group" "eks_sg" {
  name        = "${var.eks_cluster_name}-eks-sg"
  description = "Allow all inbound and outbound traffic for EKS cluster"
  vpc_id      = var.vpc_id

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.eks_cluster_name}-eks-sg"
    Environment = var.environment
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_cluster_name}-${var.environment}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [aws_security_group.eks_sg.id] # Attach security group
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  tags = {
    Name        = "${var.eks_cluster_name}-${var.environment}"
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policies]
}

### NODE GROUP CONFIGURATION

resource "aws_iam_role" "eks_node_role" {
  name = "${var.eks_cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  count      = length(var.eks_node_policies)
  role       = aws_iam_role.eks_node_role.name
  policy_arn = var.eks_node_policies[count.index]
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.eks_cluster_name}-${var.environment}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  capacity_type   = "ON_DEMAND"  # Using on-demand instances

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = [var.instance_type]

  # Enabling node auto-repair
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  tags = {
    Name        = "${var.eks_cluster_name}-${var.environment}-node-group"
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.eks_node_policies]
}

### ADD-ONS

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "node_monitoring" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "eks-node-monitoring-agent"
}