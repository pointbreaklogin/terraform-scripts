variable "aws_region" {
    description = "Default reagion"
    type = string
    default = "ap-south-1"
}

#Ec2 variables
variable "instance_ami" {
    description = "Ubuntu LTS free tier installation"
    type = string
    default = "ami-00bb6a80f01f03502"
}
variable "instance_type" {
    description = "Ec2 instance type"
    type = string
    default = "t2.micro"
}
variable "instance_port" {
    description = "Port number for the application"
    type = string
    default = "8080"
}
variable "instance_storage" {
  description = "storage size for instance"
  type = string
  default = "8"
}

#ssh key name and path
variable "key_name" {
  description = "Name of the ssh key pair"
  type = string
  default = "pointbreak-auto-tf-key"
}
variable "local_key_path" {
    description = "path of the ssh public key"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

#database variables
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}
variable "db_password" {
  description = "Password for the RDS instance (store securely in AWS Secrets Manager)"
  type        = string
  default     = "Testpass4u4z"
}
variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
  default     = "pointbreak_test_tf_db"
}
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}
variable "storage_type" {
    description = "Storage type for RDS instance"
    type = string
    default = "gp2"
}
variable "allocated_storage" {
  description = "Initial storage for the RDS instance (in GB)"
  type        = number
  default     = 10
}
variable "max_allocated_storage" {
  description = "Maximum storage limit for RDS instance (in GB)"
  type        = number
  default     = 20
}
variable "mysql_port" {
    description = "Port for mysql"
    type = string
    default = "3306"
}

#Block for common rule
variable "vpc_common_cidr" {
  description = "Common cidr rule"
  type        = string
  default     = "0.0.0.0/0"
}

#Route53 configuration
variable "domain" {
  description = "pointbreak.space"
  type        = string
}


