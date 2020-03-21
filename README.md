# Poorman's GitOps
- Build a docker image and deploy to ECR with SHA1 as the tag name
- Replace `$GITREF` in `kubernetes/**/*.yaml` file with SHA1
- `kubectl apply -f .`
