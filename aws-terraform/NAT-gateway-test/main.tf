provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "12.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}
#Internet gatewayblock
# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-internet-gateway"
  }
}


#Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "12.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet-1"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "12.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "my-private-subnet-1"
  }
}

#public route table setup
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "my_public_route_table"
  }
}
#assocate public route table with public subnet
resource "aws_route_table_association" "public_rt_assocation" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

#private route table  no internet route
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my_private_route_table"
  }
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_rt_assocation" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}