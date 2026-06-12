output "dev_vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "dev_subnet_id" {
  value = module.dev_vpc.public_subnets[0]
}

output "dev_instance_id" {
  value = module.dev_ec2.instance_id
}

output "dev_instance_public_ip" {
  value = module.dev_ec2.instance_public_ip
}

output "prod_vpc_id" {
  value = module.prod_vpc.vpc_id
}

output "prod_subnet_id" {
  value = module.prod_vpc.public_subnets[0]
}

output "prod_instance_id" {
  value = module.prod_ec2.instance_id
}

output "prod_instance_public_ip" {
  value = module.prod_ec2.instance_public_ip
}

