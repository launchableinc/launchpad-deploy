#!/bin/bash
export AWS_ACCESS_KEY_ID="$INPUT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$INPUT_AWS_SECRET_ACCESS_KEY"

set -xe
# push image
$(aws ecr get-login --no-include-email --region "$INPUT_AWS_REGION")
ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account')
REMOTE=$ACCOUNT.dkr.ecr.$INPUT_AWS_REGION.amazonaws.com/$INPUT_IMAGE:$GITHUB_SHA
docker tag $INPUT_IMAGE $REMOTE
docker push $REMOTE

# apply config
if [ "${GITHUB_REF}" = "refs/heads/master" ]; then
    aws eks --region "$INPUT_AWS_REGION" update-kubeconfig --name "$INPUT_CLUSTER_NAME"
    cd kubernetes
    find . -type f -name '*.yaml' | xargs perl -i -p -e "s/\$GITREF/${GITHUB_SHA}/g;" 
    kubectl apply -f .
fi
