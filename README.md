# Arkaela AI Infrastructure

This repository defines the Kubernetes infrastructure and applications that run in our clusters, using a GitOps approach.

## Description

This project follows a modular structure to manage Kubernetes clusters and their deployments. It is based on:
-   **Terraform:** For provisioning the underlying infrastructure (VPC, EKS/AKS/GKE, databases).
-   **Kustomize:** For managing Kubernetes manifests, allowing for reuse and environment-specific overrides.
-   **GitOps (FluxCD/Argo CD):** The desired state of our clusters is declared in this Git repository, and a GitOps tool synchronizes the clusters.

## Prerequisites

Make sure you have the following tools installed on your machine:

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
* [Terraform](https://www.terraform.io/downloads.html)
* [aws-cli / az cli / gcloud cli](https://aws.amazon.com/cli/ / https://docs.microsoft.com/en-us/cli/azure/install-azure-cli / https://cloud.google.com/sdk/docs/install) (según tu proveedor de nube)
* [Git](https://git-scm.com/downloads)

## Quick Start (Development Local)

To bootstrap a development cluster (e.g. Kind or Minikube) and deploy `app1`:

1.  **Create a local cluster (e.g. Kind):**
    ```bash
    kind create cluster --name my-dev-cluster
    kubectl cluster-info --context kind-my-dev-cluster
    ```
2.  **Apply the base manifests of `app1` directly (for quick development):**
    ```bash
    kubectl apply -k base/apps/app1
    ```
3.  **Apply the environment-specific overrides for `app1` (if any):**
    ```bash
    kubectl apply -k clusters/dev/services
    ```
4.  **Verify the deployments:**
    ```bash
    kubectl get pods -n default # or your app's namespace
    ```

## Project Structure
```
arkoifa/
├── clusters/           # Environment-specific configurations (production, staging, dev)
│   ├── production/
│   ├── staging/
│   └── dev/
├── base/               # Base Kubernetes configurations (common to all environments)
│   ├── apps/           # Base Kubernetes manifests for applications
│   └── infra/          # Base Kubernetes manifests for infrastructure (RBAC, Networking)
├── scripts/            # Scripts for CI/CD and operations automation
├── terraform/          # Terraform code for the underlying infrastructure
│   ├── production/
│   ├── staging/
│   ├── dev/
│   └── modules/        # Reusable Terraform modules
├── .github/            # GitHub Actions workflows (CI/CD)
└── docs/               # Project documentation
```