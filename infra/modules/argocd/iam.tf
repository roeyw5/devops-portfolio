# ArgoCD IAM Resources
#  * ArgoCD IAM Policy
#  * ArgoCD IAM Role
#  * ArgoCD IAM Role Policy Attachment

resource "aws_iam_policy" "argocd_secrets_policy" {
  name = "roey-pf-argocd-secrets-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:argocd-ssh-key"
      }
    ]
  })
}

resource "aws_iam_role" "argocd_role" {
  name = "roey-pf-argocd-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "argocd_secrets_attachment" {
  policy_arn = aws_iam_policy.argocd_secrets_policy.arn
  role       = aws_iam_role.argocd_role.name
}
