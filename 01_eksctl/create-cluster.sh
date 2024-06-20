#!/bin/bash

# Variables
CLUSTER_NAME=eks-mundos-e
AWS_REGION=us-east-1

# Establecer credenciales de AWS 
aws sts get-caller-identity >> /dev/null  # Este comando verifica las credenciales de AWS para asegurarse de que estén configuradas correctamente.
# 1-.(aws sts get-caller-identity) Obtiene información sobre la identidad del usuario o servicio que está realizando la llamada.
# 2-.(>> /dev/null) Redirige la salida estándar (stdout) al archivo /dev/null, lo que significa que no se mostrará en la consola.
if [ $? -eq 0 ] # Verifica si el comando anterior se ejecutó correctamente (es decir, si su código de salida es 0, todo esta bien).
then
  echo "Credenciales testeadas, proceder con la creacion de cluster."

  # Creacion de cluster
  eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $AWS_REGION \
  --nodes 3 \
  --node-type t2.micro \
  --with-oidc \  # Habilita la autenticación OIDC (OpenID Connect) para el clúster.
  --ssh-access \ # Permite el acceso SSH a los nodos del clúster.
  --ssh-public-key final-mundosE \  # Indicar el nombre de la key.pem.
  --managed \  # Crea un clúster administrado por EKS.
  --full-ecr-access \
  --zones us-east-1a,us-east-1b,us-east-1c # Define las zonas de disponibilidad en las que se distribuirán los nodos del clúster

  if [ $? -eq 0 ]
  then
    echo "Cluster Setup Completo con eksctl ."
  else
    echo "Cluster Setup Falló mientras se ejecuto eksctl."
  fi
else
  echo "Por favor, ejecute aws configure y establezca las credenciales correctas."
  echo "Error en la configuración del cluster"
fi
