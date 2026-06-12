data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}


module "prod_vpc" {
  source        = "terraform-aws-modules/vpc/aws"
  version       = "5.0.0"
  name          = "${var.project_name}-prod"
  cidr          = var.prod_vpc_cidr
  azs           = [data.aws_availability_zones.available.names[0]]
  public_subnets = var.prod_subnet_cidr

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-prod-vpc"
  }
}

module "dev_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name           = "${var.project_name}-dev"
  cidr           = var.dev_vpc_cidr
  azs            = [data.aws_availability_zones.available.names[0]]
  public_subnets = var.dev_subnet_cidr

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-dev-vpc"
  }
}

module "dev_ec2" {
  source        = "./modules/ec2"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.dev_vpc.public_subnets[0]
  project_name  = "${var.project_name}-dev"
}

module "prod_ec2" {
  source        = "./modules/ec2"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.prod_vpc.public_subnets[0]
  project_name  = "${var.project_name}-prod"
}

