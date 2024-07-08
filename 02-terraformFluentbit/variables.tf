#variable "registry" {
#  description = "A list of A records to create in the Route 53 zone."
#  type = list(object({
#    name    = string
#    records = list(string)
#  }))
#  default = []
#}
#variable "hosted_zone_id" {
#  type = string
#}
#
#variable "is_private" {
#  type = bool
#}
#variable tags {
#  type = map(string)
#}

##variables para ec2
# variable "instance_name" {
#   description = "The name of the EC2 instance"
#   type        = string
# }

# variable "tags" {
#   description = "The tags to attach to the EC2 instances and EBS volumes"
#   type        = map(string)
# }

# variable "custom_ami" {
#   description = "Custom AMI to use for the EC2 instances. If not provided, the latest Amazon Linux 2 or Windows AMI will be used"
#   type        = string
#   default     = false
# }

# variable "iam_instance_profile_name" {
#   description = "The IAM profile to attach to the EC2 instances"
#   type        = string
# }

# variable "subnet_id" {
#   description = "The subnet ID to launch the EC2 instances"
#   type        = string
# }

# variable "key_name" {
#   description = "The key pair name to attach to the EC2 instances"
#   type        = string
#   default     = ""
# }

# variable "instance_type" {
#   description = "The instance type to launch the EC2 instances"
#   type        = string
# }

# variable "security_group_ids" {
#   description = "The security group IDs to attach to the EC2 instances"
#   type        = list(string)
# }

# #variable "user_data_file_name" {
# #  description = "The name of the user data file. Must be inside a directory named 'user_data' in the root of the module"
# #  type        = string
# #  default     = ""
# #}

# variable "network_interface" {
#   description = "Customize network interfaces to be attached at instance boot time"
#   type        = list(map(string))
#   default     = []
# }

# variable "root_block_device" {
#   description = "Customize details about the root block device of the instance. See Block Devices below for details"
#   type        = list(any)
#   default     = []
# }

# variable "ebs_block_device" {
#   description = "Additional EBS block devices to attach to the instance"
#   type        = list(any)
#   default     = []
# }

# variable "aws_access_key_id" {
#   type = string
#   sensitive = true
# }

# variable "aws_secret_access_key" {
#   type = string
#   sensitive = true
# }

# # Optional: Define variables for cluster configuration
# variable "cluster_name" {
#   type = string
#   default = "mundoes-cluster-G6"
# }

# variable "aws_region" {
#   type = string
#   default = "us-east-2"
# }

# variable "node_count" {
#   type = number
#   default = 3
# }

# variable "node_type" {
#   type = string
#   default = "t2.small"
# }

# variable "vpc_id" {
#   description = "VPC ID where the EKS cluster and nodes will be launched"
#   type        = string
# }

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

# variable "grafana_values" {
#   description = "Contenido del archivo grafana-values.yaml"
#   type        = string
# }

#  variable "region" {
#    default = "us-east-1"
#  }


variable "region" {
  description = "La región de AWS donde se desplegará el clúster EKS"
  type        = string
}

variable "grafana_values" {
  description = "Configuración en formato YAML para Grafana"
  type        = string
}


#  variable "eks_cluster_endpoint" {
#    description = "Endpoint del clúster EKS"
#    type        = string
#  }

#  variable "eks_cluster_auth_token" {
#    description = "Token de autenticación del clúster EKS"
#    type        = string
#  }

#  variable "eks_cluster_ca_certificate" {
#    description = "Certificado CA del clúster EKS en formato base64"
#    type        = string
#  }
