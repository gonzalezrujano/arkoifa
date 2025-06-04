#!/bin/bash
set -eo pipefail

echo "Updating the cluster..."

ENV=${1:-dev} # Default to 'dev'
KUSTOMIZE_DIR="./clusters/${ENV}"

if [ ! -d "$KUSTOMIZE_DIR" ]; then
    echo "Error: Kustomize directory for environment '$ENV' not found in '$KUSTOMIZE_DIR'"
    exit 1
fi

echo "Applying Kubernetes manifest updates with Kustomize for environment: $ENV"
kubectl apply -k "$KUSTOMIZE_DIR"

echo "Cluster updated for environment: $ENV"