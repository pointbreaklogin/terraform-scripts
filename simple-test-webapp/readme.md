# Terraform AWS Infrastructure Setup

## Overview
This Terraform script provisions an AWS infrastructure that includes:
- An EC2 key pair for SSH access
- Security groups for EC2 instances and an Application Load Balancer (ALB)
- An ALB with a target group
- Two EC2 instances running a Python HTTP server on port 8080
- Route 53 DNS setup for domain `pointbreak.space`


### 1. AWS Key Pair
- Creates a key pair (`pointbreak-auto-tf-key`) using a local public key for secure SSH access.

### 2. AWS Security Groups
- `pointbreak_auto_tf_sg`: Allows inbound traffic on port 8080.
- `pointbreak-tf-alb-sg`: Allows inbound HTTP (port 80) traffic for the ALB.

### 3. AWS Application Load Balancer (ALB)
- Routes traffic to the target group (`pointbreak-tf-target-group`).
- Returns a `404: page not found` response for unmatched routes.

### 4. AWS EC2 Instances
- Two instances (`pointbreak-tr-instance-1` and `pointbreak-tr-instance-2`).
- Each instance runs a Python HTTP server on port 8080.
- Instances are added to the ALB target group.

### 5. AWS Route 53
- Configures a hosted zone for `pointbreak.space`.
- Creates an A record to route traffic to the ALB.

### 6. AWS RDS instance - free tier
- Configures RDS free tier instance 
- Use mysql database with specific storage
- Add 3306 port to the SG

## Usage

### 1. Initialize Terraform
```sh
terraform init
```

### 2. Apply the Configuration
```sh
terraform apply -auto-approve
```
This will provision all the resources in AWS.

### 3. Destroy the Infrastructure
```sh
terraform destroy -auto-approve
```
This will remove all created resources, including the EC2 instances, security groups, ALB, and Route 53 records.

## Notes
- Ensure that you have an existing public key at `~/.ssh/id_rsa.pub` before applying the Terraform script.
- The instances will automatically start serving a basic Python web server on port 8080.
- Security groups allow inbound HTTP (port 80) traffic to the ALB and inbound 8080 traffic to the EC2 instances.
- The domain `pointbreak.space` must be registered and properly configured in Route 53.

