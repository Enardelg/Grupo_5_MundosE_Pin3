#!/bin/bash

#1-. Preparar kubectl para comunicarse con el cluster
aws eks --region us-east-1 update-kubeconfig --name eks-mundos-e
#2-. Intentar ver contenido con otro usuario
aws configure --profile <nombre-usuario>
#3-. Configura kubeconfig para el usuario anteriormente insertado
aws eks --region us-east-1 update-kubeconfig --name <nombre-cluster> --profile <nombre-usuario>
#4-. Intenta ver info del cluster
kubectl get nodes
#**tendria que figurar este error: 
#Error from server (Forbidden): nodes is forbidden: User "arn:aws:iam::123456789012:user/new-user" cannot list resource "nodes" in API group "" at the cluster scope
