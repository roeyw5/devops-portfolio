# DevOps Portfolio Project

## Overview

This portfolio project demonstrates various aspects of DevOps practices through a comprehensive setup involving application development, CI/CD pipelines, cloud-based infrastructure, microservices, GitOps, logging, and monitoring.

### Repositories

1. **Application** (`app`): Contains the application code written in Python (Flask), with a REST API interacting with a MongoDB database.
2. **GitOps Configuration** (`gitops`): Holds the GitOps setup using Argo CD for continuous deployment.
3. **Infrastructure** (`infra`): Manages the cloud infrastructure using Terraform, including Kubernetes provisioning and networking.

## Architecture

The project follows a microservice-based architecture deployed on AWS using EKS for Kubernetes orchestration. The infrastructure is managed through Terraform, ensuring a consistent and reproducible setup. The application is containerized using Docker and follows a GitOps approach for deployments.

![Architecture Diagram](gitops/images/Full_architecture.png)

## Technology Stack

- **Terraform:** For provisioning and managing infrastructure as code.
- **AWS:** For hosting the infrastructure, including VPC, EC2, EKS, ECR, S3, IAM, Secrets and related services.
- **Kubernetes:** For orchestrating containerized applications.
- **Helm:** For managing Kubernetes applications using Helm charts.
- **ArgoCD:** For implementing GitOps-based continuous deployment.
- **GitLab:** For version control and CI/CD pipeline management.
- **Python (Flask):** For development, including building REST APIs.
- **Docker:** For containerizing applications.
- **Jenkins:** For continuous integration and deployment pipelines.
- **MongoDB:** For database management.
- **Nginx Ingress Controller:** For managing inbound traffic to the Kubernetes cluster.
- **EFK Stack:** For centralized logging using Elasticsearch, Fluentd, and Kibana.
- **Prometheus and Grafana:** For monitoring and observability of the infrastructure and applications.

## Documentation

Each repository includes a `README.md` file with detailed documentation about its purpose, setup, and detailed structure.

## Contact

For any questions or suggestions, feel free to reach out.
