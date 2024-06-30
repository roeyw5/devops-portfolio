output "worker_role_arn" {
  value = aws_iam_role.worker_nodes.arn
}

output "node_group_name" {
  value = aws_eks_node_group.node_group.node_group_name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.roey-pf.token
}
