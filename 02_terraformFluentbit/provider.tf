# AWS provider version definition
 terraform {
   required_version = ">= 1.0"

   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "~> 5.0"
     }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
        }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
      }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }

  }
 
   backend "s3" {
     bucket         = "BUCKET_NAME"
     key            = "global/PROJECT_NAME/terraform.tfstate"
     dynamodb_table = "DYNAMO_NAME"
     region         = "us-east-1"
     encrypt        = true
    }
 }

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


#  provider "kubernetes" {
#      host                   = data.aws_eks_cluster.eks_cluster.endpoint
#      token                  = data.aws_eks_cluster_auth.eks_cluster.token
#      cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
#  }