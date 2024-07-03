#!/bin/bash
# Recibe IAM_USER_ARN como $1 y KUBE_NAMESPACE como $2
IAM_USER_ARN=$1
KUBE_NAMESPACE=$2
PROFILE_NAME=$3

# Edita el ConfigMap aws-auth
kubectl get configmap aws-auth -n $KUBE_NAMESPACE -o yaml > aws-auth.yaml
cat <<EOT >> aws-auth.yaml
    - userarn: $IAM_USER_ARN
      username: $PROFILE_NAME
      groups:
        - system:masters
EOT
kubectl apply -f aws-auth.yaml -n $KUBE_NAMESPACE
