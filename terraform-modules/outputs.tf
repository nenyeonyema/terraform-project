output "dev_vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "dev_subnet_id" {
  value = module.dev_vpc.subnet_id
}

output "dev_instance_id" {
  value = aws_instance.dev_web.id
}

output "dev_instance_public_ip" {
  value = aws_instance.dev_web.public_ip
}

output "prod_vpc_id" {
  value = module.prod_vpc.vpc_id
}

output "prod_subnet_id" {
  value = module.prod_vpc.subnet_id
}

output "prod_instance_id" {
  value = aws_instance.prod_web.id
}

output "prod_instance_public_ip" {
  value = aws_instance.prod_web.public_ip
}
