# General 
variable "region" {
  description = "The AWS region"
  type        = string
}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
variable "account_id" {
  description = "The ID of the account"
  type        = string
}
variable "project_name" {
  description = "The name of the project"
  type        = string
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
variable "key_pair_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# VPC and Subnets
variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}
variable "cidr_blocks_public_subnet" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}
variable "cidr_blocks_private_subnet" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

# EKS Cluster & Nodes
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "instance_type" {
  description = "Instance type for the worker nodes"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the worker nodes"
  type        = string
}
variable "disk_size" {
  description = "Size of the disk for the node group"
  type        = number
}
variable "capacity_type" {
  description = "Capacity type for the node group"
  type        = string
}
variable "scaling_desired" {
  description = "Amount of worker nodes"
  type        = number
}
variable "scaling_min" {
  description = "Min amount of worker nodes"
  type        = number
}
variable "scaling_max" {
  description = "Max amount of worker nodes"
  type        = number
}
variable "max_unavailable" {
  description = "Maximum number of nodes unavailable during the update"
  type        = number
}

# ArgoCD
variable "argocd_namespace" {
  description = "Namespace for ArgoCD"
  type        = string
}
variable "argocd_release_name" {
  description = "Release name for ArgoCD"
  type        = string
}
variable "argocd_repository" {
  description = "Helm repository for ArgoCD"
  type        = string
}
variable "argocd_chart" {
  description = "Helm chart for ArgoCD"
  type        = string
}
variable "argocd_version" {
  description = "Helm chart version for ArgoCD"
  type        = string
}
variable "ssh_key_secret_id" {
  description = "Secret ID for the SSH key in AWS Secrets Manager"
  type        = string
}
variable "repo_creds_name" {
  description = "Name of the repository credentials secret"
  type        = string
}
variable "repo_creds_repo_name" {
  description = "Repository name for the ArgoCD repo credentials"
  type        = string
}
variable "repo_creds_type" {
  description = "Type of repository"
  type        = string
}
variable "repo_creds_project" {
  description = "Project name for the repository credentials"
  type        = string
}
variable "repo_url" {
  description = "Repository URL for the ArgoCD applications"
  type        = string
}
variable "sync_options" {
  description = "Sync options for ArgoCD applications"
  type        = list(string)
}

# App
variable "weather_app_namespace" {
  description = "Namespace for the weather application"
  type        = string
}
variable "infra_app_namespace" {
  description = "Namespace for the infrastructure applications"
  type        = string
}
variable "weather_app_path" {
  description = "Path to the weather app in the repository"
  type        = string
}
variable "infra_app_path" {
  description = "Path to the infra app in the repository"
  type        = string
}
