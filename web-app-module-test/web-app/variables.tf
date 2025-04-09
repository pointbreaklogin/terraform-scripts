#web-app/variables.tf

#General variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_common_cidr" {
  description = "CIDR block for security group rules"
  type        = string
}

#SSH Key variables
variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "local_key_path" {
  description = "Path to local public key file"
  type        = string
}

#Instance related variable
variable "instance_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_storage" {
  description = "Root volume size in GB"
  type        = number
}

variable "instance_port" {
  description = "Port for web server"
  type        = number
}

#RDS instance related variable
variable "mysql_port" {
  description = "MySQL database port"
  type        = number
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage allocation (GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum storage allocation (GB)"
  type        = number
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
}

#DNS Route53 related variable
variable "domain" {
  description = "Route53 domain name"
  type        = string
}
