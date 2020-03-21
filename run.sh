#!/bin/bash
export AWS_ACCESS_KEY_ID="$INPUT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$INPUT_AWS_SECRET_ACCESS_KEY"

set +x
aws eks --region "$INPUT_AWS_REGION" update-kubeconfig --name "$INPUT_CLUSTER_NAME"
cd kubernetes
find . -type f -name '*.yaml' | xargs perl -i -p -e "s/\$GITREF/${GITHUB_SHA}/g;" 
kubectl apply -f .
