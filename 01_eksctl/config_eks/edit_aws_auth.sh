#!/bin/bash
# ||ATENCION|| Para editar el archivo  ConfigMap aws-auth, el user admin debe tener los siguientes politcas:
#*AmazonEKSClusterPolicy
#*IAMFullAccess
#*AmazonEC2ReadOnlyAccess

#1-. kubectl edit configmap aws-auth -n kube-system
Agrega este bloque de codigo: 
mapUsers: |
    - userarn: arn:aws:iam::123456789012:user/your-iam-user
      username: your-iam-user
      groups:
        - system:masters
#2-. Verificar configuracion
kubectl get configmap -n kube-system
Una forma rápida y útil de listar y verificar todos los ConfigMaps presentes en el namespace kube-system. Esto puede ayudarte a asegurar que los componentes del sistema de Kubernetes están correctamente configurados y operativos.
#3-. Ver el archivo ConfigMap
kubectl describe configmap aws-auth -n kube-system
#4-. Intenta ver info del cluster
kubectl get nodes
#** Ahora ya como esta agregado el usuario, tienes acceso al cluster :)
