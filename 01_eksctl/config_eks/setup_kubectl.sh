#!/bin/bash
# Configura kubectl para el usuario administrador
AWS_REGION=$1
CLUSTER_NAME=$2

aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
kubectl get nodes
