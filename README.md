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

### Development

- **Language**: Python (Flask)
- **API**: REST

### Containerization

- **Docker**

### Source Code Management

- **Gitlab**

### CI/CD

- **Jenkins**

### Database

- **MongoDB**

### Infrastructure as Code

- **Terraform**

### Cloud Provider

- **AWS**

### Kubernetes

- **EKS**
- **Helm**

### Ingress

- **Nginx Ingress Controller**

### GitOps

- **Argo CD**

### Logging

- **EFK Stack**

### Monitoring

- **Prometheus and Grafana**

## Documentation

Each repository includes a `README.md` file with detailed documentation about its purpose, setup, and usage instructions.

## Contact

For any questions or suggestions, feel free to reach out.
