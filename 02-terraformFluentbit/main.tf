 # # IAM role para el cluster EKS
  resource "aws_iam_role" "eks_cluster_role" {
    name = "eks-cluster-role"
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }
      ]
    })
  }

 # Política de IAM para el cluster EKS
 resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
   role       = aws_iam_role.eks_cluster_role.name
 }

 resource "aws_iam_role_policy_attachment" "eks_service_policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
   role       = aws_iam_role.eks_cluster_role.name
 }

# KMS key para cifrado del cluster EKS
 resource "aws_kms_key" "eks_cluster_key" {
   description             = "KMS key for EKS cluster encryption"
   key_usage               = "ENCRYPT_DECRYPT"
   deletion_window_in_days = 30
   enable_key_rotation     = true
   policy = jsonencode({
     Version = "2012-10-17"
     Statement = [
       {
         Effect    = "Allow"
         Principal = {
           AWS = "arn:aws:iam::783732176237:root"
         }
         Action   = "kms:*"
         Resource = "*"
       }
     ]
   })
  
   tags = {
     Name = "eks-cluster-key"
   }
 }

 # Configuración del cluster EKS
 resource "aws_eks_cluster" "eks_cluster" {
   name     = "eks-mundos-e"
   role_arn = aws_iam_role.eks_cluster_role.arn
   vpc_config {
     subnet_ids              = var.subnet_ids
     endpoint_public_access  = true
     endpoint_private_access = true
     public_access_cidrs     = ["0.0.0.0/0"]
   }

   enabled_cluster_log_types = [
     "api",
     "audit",
     "authenticator",
     "controllerManager",
     "scheduler",
   ]

   encryption_config {
     resources = ["secrets"]
     provider {
       key_arn = aws_kms_key.eks_cluster_key.arn
     }
   }
 }

 # IAM role para los nodos del cluster EKS
 resource "aws_iam_role" "eks_node_role" {
   name = "eks-node-role"
   assume_role_policy = jsonencode({
     Version = "2012-10-17"
     Statement = [
       {
         Action = "sts:AssumeRole"
         Effect = "Allow"
         Principal = {
           Service = "ec2.amazonaws.com"
         }
       }
     ]
   })
 }

 # Políticas de IAM para los nodos de trabajo del cluster EKS
 resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
   role       = aws_iam_role.eks_node_role.name
 }

 resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
   role       = aws_iam_role.eks_node_role.name
 }

 resource "aws_iam_role_policy_attachment" "eks_ecr_full_access_policy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
   role       = aws_iam_role.eks_node_role.name
 }

 # Configuración del grupo de nodos del cluster EKS
 resource "aws_eks_node_group" "eks_nodes" {
   cluster_name    = aws_eks_cluster.eks_cluster.name
   node_group_name = "eks-nodes"
   node_role_arn   = aws_iam_role.eks_node_role.arn
   subnet_ids      = var.subnet_ids

   instance_types = ["t3.small"]
  
   scaling_config {
     desired_size = 3
     max_size     = 3
     min_size     = 1
   }
 }

#  # Recuperar la autenticación del clúster EKS
#   data "aws_eks_cluster_auth" "eks_cluster" {
#     name = aws_eks_cluster.eks_cluster.name
#   }

# Configurar kubectl y ejecutar comandos adicionales
# resource "null_resource" "setup_kubectl_and_apps" {
#   provisioner "local-exec" {
#     command = <<-EOT
#       aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} --region ${var.region}
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml
#       curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#       chmod +x get_helm.sh
#       ./get_helm.sh
#       helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#       helm repo add grafana https://grafana.github.io/helm-charts
#       helm repo update
#       kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.7"
#       kubectl create namespace prometheus || true
#       helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"
#       kubectl create namespace grafana || true
#       echo '${var.grafana_values}' > grafana-values.yaml
#       helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='EKS!sAWSome' --values grafana-values.yaml --set service.type=LoadBalancer
#     EOT
#   }
# }

resource "null_resource" "setup_kubectl_and_apps" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} --region ${var.region}
      export TOKEN=$(aws eks get-token --cluster-name ${aws_eks_cluster.eks_cluster.name} | jq -r '.status.token')
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml --token=$TOKEN
      kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.7"
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
      chmod +x get_helm.sh
      ./get_helm.sh
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo add grafana https://grafana.github.io/helm-charts
      helm repo update
      kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.7" --token=$TOKEN
      kubectl create namespace prometheus || true
      helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"
      kubectl create namespace grafana || true
      echo '${var.grafana_values}' > grafana-values.yaml
      helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='EKS!sAWSome' --values grafana-values.yaml --set service.type=LoadBalancer
    EOT
  }
}

#  resource "null_resource" "setup_kubectl_and_apps" {
#    provisioner "local-exec" {
#     command = <<-EOT
#       aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} --region ${var.region}
#       export TOKEN=$(aws eks get-token --cluster-name ${aws_eks_cluster.eks_cluster.name} | jq -r '.status.token')
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml --token=$TOKEN --validate=false
#       curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#       chmod +x get_helm.sh
#       ./get_helm.sh
#       helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#       helm repo add grafana https://grafana.github.io/helm-charts
#       helm repo update
#       kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.7" --token=$TOKEN --validate=false
#       kubectl create namespace prometheus || true
#       helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"
#       kubectl create namespace grafana || true
#       echo '${var.grafana_values}' > grafana-values.yaml
#       helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='EKS!sAWSome' --values grafana-values.yaml --set service.type=LoadBalancer
#     EOT
# } 
# }


