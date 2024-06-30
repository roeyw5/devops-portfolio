# Providers specificly for the module
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.13.2"
    }
  }
}
