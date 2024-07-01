# Compute Resources
#  * EKS Cluster
#  * EKS Node Group
#  * Null resource to modify instance metadata options
#  * EKS Cluster Token
#  * EKS Addon for managing volumes
#  * EBS Storage Class

# EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_policy
  ]
}

# EKS node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.worker_nodes.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.instance_type]
  disk_size       = var.disk_size
  capacity_type   = var.capacity_type

  scaling_config {
    desired_size = var.scaling_desired
    max_size     = var.scaling_max
    min_size     = var.scaling_min
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_cni_policy,
    aws_iam_role_policy_attachment.worker_registry_policy,
    aws_iam_role_policy_attachment.ebs_csi_policy,
    aws_eks_cluster.eks
  ]

  tags_all = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Null resource to run script for modifying instance metadata options
resource "null_resource" "modify_instance_metadata" {
  provisioner "local-exec" {
    command = <<EOT
      ./fix-pv.sh
    EOT
  }

  depends_on = [
    aws_eks_node_group.node_group
  ]
}

# Cluster token
data "aws_eks_cluster_auth" "roey-pf" {
  name = var.cluster_name
}



# Addon for managing volumes
resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"
  depends_on   = [aws_eks_cluster.eks]
}

# EBS Storage Class
resource "kubernetes_storage_class" "ebs-class" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    "type" = "gp3"
  }
}
