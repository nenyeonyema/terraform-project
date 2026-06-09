variable "region" {
  type    = string
  default = "us-east-1"
}

variable "dev_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "dev_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "prod_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "prod_subnet_cidr" {
  type    = string
  default = "10.1.1.0/24"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "project_name" {
  type    = string
  default = "nenye-terraform-module"
}
