#!/bin/bash
# Recibe IAM_USER_ARN como $1, KUBE_NAMESPACE como $2 y PROFILE_NAME como $3
IAM_USER_ARN=$1
KUBE_NAMESPACE=$2
PROFILE_NAME=$3

# Edita el ConfigMap aws-auth
kubectl get configmap aws-auth -n $KUBE_NAMESPACE -o yaml > aws-auth.yaml

# Verifica si el bloque mapUsers existe y agrégalo si no está presente
if ! grep -q 'mapUsers:' aws-auth.yaml; then
    echo "mapUsers: |" >> aws-auth.yaml
fi

# Agrega el nuevo usuario al bloque mapUsers
cat <<EOT >> aws-auth.yaml
    - userarn: $IAM_USER_ARN
      username: $PROFILE_NAME
      groups:
        - system:masters
EOT

# Aplica los cambios al ConfigMap aws-auth
kubectl apply -f aws-auth.yaml -n $KUBE_NAMESPACE
