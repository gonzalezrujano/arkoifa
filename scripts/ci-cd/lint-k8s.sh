#!/bin/bash
set -eo pipefail

echo "Running Kubernetes manifest linting and validation..."

# Install and use kubeconform to validate manifests
# (Requires kubeconform to be installed or installed here)
# If you don't have kubeconform, you can install it:
# curl -L https://github.com/yannh/kubeconform/releases/download/v0.6.2/kubeconform-linux-amd64.tar.gz | tar -xz && mv kubeconform /usr/local/bin/

# Install and use yamllint
# pip install yamllint

echo "Validating with yamllint..."
yamllint .

echo "Validating Kustomize manifests with 'kubectl kustomize' dry-run..."
# This renders the manifests for each environment and validates them syntactically
for env_dir in clusters/*/; do
    ENV=$(basename "$env_dir")
    echo "  Validating environment: $ENV"
    # Renders the manifests for validation syntactically
    kubectl kustomize "clusters/${ENV}" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Kustomize failed for environment $ENV"
        exit 1
    fi
done

echo "Validating with kubeconform (requires a running cluster or local CRDs):"
# kubeconform -strict -summary clusters/production/*.yaml # This is for individual files
# To validate the entire Kustomize overlay:
for env_dir in clusters/*/; do
    ENV=$(basename "$env_dir")
    echo "  Validating rendered manifests of $ENV with kubeconform..."
    kubectl kustomize "clusters/${ENV}" | kubeconform --strict
    if [ $? -ne 0 ]; then
        echo "Error: Kubeconform failed for environment $ENV"
        exit 1
    fi
done

echo "Kubernetes manifest validation completed successfully."