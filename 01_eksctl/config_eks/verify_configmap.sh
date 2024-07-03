#!/bin/bash
# Recibe KUBE_NAMESPACE como $1
KUBE_NAMESPACE=$1

# Verifica los cambios en el ConfigMap
kubectl get configmap aws-auth -n $KUBE_NAMESPACE
kubectl describe configmap aws-auth -n $KUBE_NAMESPACE

#!/bin/bash
# Verifica el acceso al clúster después de modificar el ConfigMap
kubectl get nodes
