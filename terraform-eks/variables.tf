variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name prefix for all resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes version for EKS cluster"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for EKS worker nodes"
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}
