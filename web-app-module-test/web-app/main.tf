provider "aws" {
  region = var.aws_region
}

module "web_app" {
  source = "../web-app-module/"


  aws_region             = var.aws_region
  instance_ami           = var.instance_ami
  instance_type          = var.instance_type
  instance_storage       = var.instance_storage
  instance_port          = var.instance_port
  mysql_port             = var.mysql_port
  key_name               = var.key_name
  local_key_path         = var.local_key_path
  vpc_common_cidr        = var.vpc_common_cidr

  domain                 = var.domain

  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_instance_class      = var.db_instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
}

output "instance1_ip_addr" {
  value = module.web_app.instance1_ip
}

output "instance2_ip_addr" {
  value = module.web_app.instance2_ip
}
