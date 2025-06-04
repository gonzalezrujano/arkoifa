#!/bin/bash
set -eo pipefail

echo "Applying Kubernetes manifests to the cluster (GitOps)."

ENV=${1:-production}
KUSTOMIZE_DIR="./clusters/${ENV}"

if [ ! -d "$KUSTOMIZE_DIR" ]; then
    echo "Error: Kustomize directory for environment '$ENV' not found in '$KUSTOMIZE_DIR'"
    exit 1
fi

echo "Applying Kustomize manifests for environment: $ENV"
kubectl apply -k "$KUSTOMIZE_DIR"

echo "Application completed for environment: $ENV"