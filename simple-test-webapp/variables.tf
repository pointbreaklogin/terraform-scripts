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
variable "db_name" {
  description = "database name"
}
variable "db_username" {
  description = "database user name"
}
variable "db_password" {
  description = "database password"
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

#domain details
variable "domain" {
  description = "Domain for the site"
}

# It is better to use a terraform.tfvars file to provide values like the ones below,  
#domain="" , db_name="", db_username="", db_password="", aws_reagin=""
# but they still need to be declared here.  
# If a value is defined in terraform.tfvars, it overrides the default value in the variables.tf file.  
# Terraform automatically loads terraform.tfvars if it exists.  
#Do NOT commit terraform.tfvars to Git, as it may contain sensitive information.

