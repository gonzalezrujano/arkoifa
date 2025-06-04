#!/bin/bash
set -eo pipefail

echo "Starting the cluster bootstrapping process..."

ENV=${1:-dev} # Default to 'dev' if not specified
TERRAFORM_DIR="./terraform/${ENV}"
KUSTOMIZE_DIR="./clusters/${ENV}"

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "Error: Terraform directory for environment '$ENV' not found in '$TERRAFORM_DIR'"
    exit 1
fi

if [ ! -d "$KUSTOMIZE_DIR" ]; then
    echo "Error: Kustomize directory for environment '$ENV' not found in '$KUSTOMIZE_DIR'"
    exit 1
fi

echo "1. Provisioning infrastructure with Terraform for the environment: $ENV"
(cd "$TERRAFORM_DIR" && terraform init && terraform apply -auto-approve)
echo "Terraform applied. Make sure the kubeconfig is configured for the new cluster."

echo "Waiting for the cluster to be ready..."
# Small pause or health check before applying Kubernetes manifests
sleep 60 # Adjust this based on your cluster's provisioning time

echo "2. Applying Kubernetes manifests with Kustomize for the environment: $ENV"
kubectl apply -k "$KUSTOMIZE_DIR"

echo "Bootstrapping completed for environment: $ENV"
echo "You can verify the cluster state with: kubectl get pods --all-namespaces"