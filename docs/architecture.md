# Kubernetes Cluster Architecture

This document describes the general architecture of our Kubernetes clusters and how the components interact.

## High-Level Diagram

```mermaid
graph TD
    subgraph CloudProvider(AWS/Azure/GCP)
        VPC[VPC/VNet] --> Subnets(Subnets/Public/Private)
        Subnets --> LB(Load Balancer)
        Subnets --> DB(Database Service - RDS/Azure DB/Cloud SQL)
        Subnets --> EKS_AKS_GKE(Cluster de Kubernetes - EKS/AKS/GKE)
    end

    EKS_AKS_GKE --> ControlPlane(Control Plane - Managed)
    EKS_AKS_GKE --> WorkerNodes(Nodes Worker)

    subgraph KubernetesCluster
        WorkerNodes --> Addons(Add-ons: Cert-Manager, Prometheus, Grafana)
        WorkerNodes --> IngressController(Nginx/ALB Ingress Controller)
        IngressController --> Application1(App1)
        IngressController --> Application2(App2)
        Application1 --> DB
        Application2 --> DB
        Addons --> Monitoring(Monitoring and Logging)
    end

    User --> LB
    LB --> IngressController
    GitRepository[Git Repository - This Project] --> GitOpsTool(FluxCD/Argo CD)
    GitOpsTool --> KubernetesCluster
    GitOpsTool --> Terraform(Terraform/IaC)
    Terraform --> CloudProvider