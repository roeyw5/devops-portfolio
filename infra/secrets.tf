# Fetch the secret data from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "roey_pf_secret" {
  secret_id = "roey-pf-secret"
}

# Fetch the SSH key from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "argocd_ssh_key" {
  secret_id = var.ssh_key_secret_id
}

locals {
  secrets_json = jsondecode(data.aws_secretsmanager_secret_version.roey_pf_secret.secret_string)
}

resource "kubernetes_secret" "roey_pf_secret" {
  metadata {
    name      = "roey-pf-secret"
    namespace = var.weather_app_namespace
  }

  data = {
    "mongodb-passwords"       = base64encode(local.secrets_json["mongodb-passwords"])
    "mongodb-root-password"   = base64encode(local.secrets_json["mongodb-root-password"])
    "mongodb-replica-set-key" = base64encode(local.secrets_json["mongodb-replica-set-key"])
    "WEATHER_API_KEY"         = base64encode(local.secrets_json["weather_api_key"])
    "WEATHER_API_URL"         = base64encode(local.secrets_json["weather_api_url"])
  }

  type       = "Opaque"
  depends_on = [kubernetes_namespace.app]
}

resource "kubernetes_secret" "argocd_repo_creds" {
  metadata {
    name      = var.repo_creds_name
    namespace = var.argocd_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    name          = var.repo_creds_repo_name
    type          = var.repo_creds_type
    project       = var.repo_creds_project
    url           = var.repo_url
    sshPrivateKey = data.aws_secretsmanager_secret_version.argocd_ssh_key.secret_string
  }
}
