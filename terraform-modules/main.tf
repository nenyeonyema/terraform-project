module "dev_vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.dev_vpc_cidr
  subnet_cidr  = var.dev_subnet_cidr
  project_name = "${var.project_name}-dev"
}

module "prod_vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.prod_vpc_cidr
  subnet_cidr  = var.prod_subnet_cidr
  project_name = "${var.project_name}-prod"
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "dev_web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.dev_vpc.subnet_id

  tags = {
    Name = "${var.project_name}-dev-web"
  }

}

resource "aws_instance" "prod_web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.prod_vpc.subnet_id

  tags = {
    Name = "${var.project_name}-prod-web"
  }
}
