#!/bin/bash
# Configura kubectl para el usuario administrador
aws eks --region us-east-1 update-kubeconfig --name eks-mundos-e
kubectl get nodes
