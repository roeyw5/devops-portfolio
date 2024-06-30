# Security Group Resources
#  * Cluster Security Group
#  * Cluster Inbound Rule
#  * Cluster Outbound Rule
#  * Node Security Group
#  * Node Internal Rule
#  * Nodes Cluster Inbound Rule

# Cluster Security Group
resource "aws_security_group" "roey-pf-cluster-sg" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-sg"
  })
}

resource "aws_security_group_rule" "cluster_inbound_rule" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.roey-pf-cluster-sg.id
  source_security_group_id = aws_security_group.roey-pf-node-sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound_rule" {
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.roey-pf-cluster-sg.id
  source_security_group_id = aws_security_group.roey-pf-node-sg.id
  to_port                  = 65535
  type                     = "egress"
}


# Node Security Group
resource "aws_security_group" "roey-pf-node-sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name                                        = "${var.project_name}_node_sg",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

# Internal communication between nodes
resource "aws_security_group_rule" "nodes_internal_rule" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.roey-pf-node-sg.id
  source_security_group_id = aws_security_group.roey-pf-node-sg.id
  to_port                  = 65535
  type                     = "ingress"
}

# Allow worker Kubelets and pods to receive communication from the cluster control plane
resource "aws_security_group_rule" "nodes_cluster_inbound_rule" {
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.roey-pf-node-sg.id
  source_security_group_id = aws_security_group.roey-pf-cluster-sg.id
  to_port                  = 65535
  type                     = "ingress"
}
