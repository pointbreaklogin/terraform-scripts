#variable declarations only
variable "aws_region" {}

variable "instance_ami" {}
variable "instance_type" {}
variable "instance_storage" {}
variable "instance_port" {}
variable "mysql_port" {}

variable "key_name" {}
variable "local_key_path" {}
variable "vpc_common_cidr" {}

variable "domain" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "db_instance_class" {}
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "storage_type" {}
