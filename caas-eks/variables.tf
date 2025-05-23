variable "project" {
  type        = string
  description = "Rafay Project name"
  default     = ""
}

variable "blueprint_name" {
  type        = string
  description = "Rafay blueprint name"
  default     = "minimal"
}

variable "blueprint_version" {
  type        = string
  description = "Blueprint version"
  default     = "latest"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}


variable "cloud_credentials_name" {
  type        = string
  description = "Rafay Cloud Credentials name"
  default     = ""
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.27"
}

#Role ARN to assume incase of using cross_account_role_arn.
# If specified, account_id is required.
variable "linked_role_arn" {
  type        = string
  description = "Role ARN to provision EKS cluster in a child/linked AWS account"
  default     = ""
}

# AWS Account ID for linked/child account incase of using cross_account_role_arn.
# If specified, linked_role_arn is required.
variable "account_id" {
  type        = string
  description = "AWS account id"
  default     = ""
}

# Service role ARN of the cluster
variable "service_role_arn" {
  type        = string
  description = "Service Role ARN"
  default     = ""
}
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for EKS Cluster"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for EKS Cluster"
  default     = []
}

#Set create_vpc to true for creating a new VPC
variable "vpc_cidr" {
  type        = string
  description = "Default VPC CIDR. This is being used when create_vpc is set to true"
  default     = "192.168.0.0/16"
}

# Set to true if VPC needs to be created using Rafay.
variable "create_vpc" {
  type    = bool
  default = false
}

variable "service_accounts" {
  type = map(object({
    name               = string
    namespace          = string
    attach_policy_arn  = string
  }))
  description = "IRSA configurations"
  default = {
    "cluster-autoscaler" = {
      name               = "cluster-autoscaler"
      namespace          = "kube-system"
      attach_policy_arn  = "arn:aws:iam::679196758854:policy/demo-cluster-autoscaler-policy"
    }
    "karpenter-sa" = {
      name               = "karpenter"
      namespace          = "karpenter"
      attach_policy_arn  = "arn:aws:iam::679196758854:policy/demo-karpenter-policy"
    }
    "em-agent-sa" = {
      name               = "em-agent-sa"
      namespace          = "rafay-system"
      attach_policy_arn  = "arn:aws:iam::679196758854:policy/demo-eaas-permissions"
    }
  }
}

variable "managed_nodegroups" {
  type = map(object({
    node_count         = number
    max_size           = number
    min_size           = number
    instance_type      = string
    #k8s_version        = string
    instance_role_arn  = string
    ami                = string
    ami_family         = string
    volume_encrypted   = bool
    private_networking = bool
    tags               = map(string)
    labels             = map(string)
  }))
  description = "Managed Nodegroup configurations"
  default = {
    "ng-1" = {
      node_count         = 1
      max_size           = 3
      min_size           = 1
      instance_type      = "t3.large"
      #k8s_version        = "1.27"
      ami                = ""
      ami_family         = "AmazonLinux2"
      volume_encrypted   = true
      private_networking = true
      instance_role_arn  = null
      tags               = null
      labels             = null
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Cluster Tags"
  default = {
    "env" = "qa"
  }
}

variable "cluster_labels" {
  type        = map(string)
  description = "Cluster Labels"
  default = {
    "provisioned-by" = "rafay"
  }
}

variable "custom_networking" {
  type        = bool
  description = "Enable/Disable custom netwokring using secondary vpc CIDRs"
  default     = false
}

variable "private_access" {
  type        = bool
  description = "Enable/Disable Private Endpoint Access For Cluster"
  default     = true
}

variable "public_access" {
  type        = bool
  description = "Enable/Disable Public Endpoint Access For Cluster"
  default     = false
}

variable "secondary_cidr" {
  type = map(object({
    availability_zone = string
    subnet            = string
    security_groups   = optional(list(string))
  }))
  default = {}
}
