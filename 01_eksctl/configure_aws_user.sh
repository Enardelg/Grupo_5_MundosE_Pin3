#!/bin/bash
# Recibe PROFILE_NAME como $1 y CLUSTER_NAME como $2
PROFILE_NAME=$1
CLUSTER_NAME=$2

# Configura AWS CLI para el perfil del nuevo usuario
aws configure --profile $PROFILE_NAME
# Actualiza kubeconfig para el nuevo usuario
aws eks --region us-east-1 update-kubeconfig --name $CLUSTER_NAME --profile $PROFILE_NAME
