# Infrastructure Repository

This repository contains the infrastructure as code (IaC) configuration for deploying and managing the cloud-based infrastructure required for the portfolio project. The infrastructure setup is based on AWS, using Terraform to provision and manage resources.

## Repository Structure

```text
terraform-infrastructure/
├── backend.tf                # Configuration for Terraform state storage
├── main.tf                   # Main Terraform configuration file
├── modules                   # Module for computing resources
│  	├── argocd                # ArgoCD module
│   │   ├── argocd.tf         # ArgoCD configuration
│   │   ├── providers.tf      # Providers configuration
│   │   ├── variables.tf      # Variables file
│   │   └── templates         # Templates for the ArgoCD applications
│   │       ├── weather_app.yaml.tpl  # Template for the weather app
│   │       └── infra_app.yaml.tpl    # Template for the infra app of apps
│   ├── compute               # Computing resources module
│   │   ├── argocd.tf         # ArgoCD resources
│   │   ├── compute.tf        # EKS cluster compute resources
│   │   ├── iam.tf            # IAM roles and policies
│   │   ├── output.tf         # Outputs for the module
│   │   ├── providers.tf      # Providers configuration
│   │   ├── sg.tf             # Security groups
│   │   └── variables.tf      # Variables file
│   └── network               # Module for networking resources
│       ├── network.tf        # Networking resources
│       ├── output.tf         # Outputs for the module
│       ├── variables.tf      # Variables for the network module
├── namespaces.tf             # Namespaces configuration
├── providers.tf              # Providers configuration for the overall infrastructure
├── secrets.tf                # Secret management for the overall infrastructure
├── terraform.tfvars          # Examples for variable values
└── variables.tf              # Variables for the overall infrastructure
```
