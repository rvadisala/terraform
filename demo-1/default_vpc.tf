# VPC Creation
resource "aws_vpc" "may_tf" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "10.0.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"
  tags = {
    Name = "may_vpc"
  }
}

# Subnet Creation
resource "aws_subnet" "public_subnet_1" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1a"
  cidr_block                      = "10.0.1.0/24"
  map_public_ip_on_launch         = "true"

  tags = {
    "Name" = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1b"
  cidr_block                      = "10.0.2.0/24"
  map_public_ip_on_launch         = "true"

  tags = {
    "Name" = "Public Subnet 2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1c"
  cidr_block                      = "10.0.3.0/24"
  map_public_ip_on_launch         = "true"

  tags = {
    "Name" = "Public Subnet 3"
  }
}

# Private subnet 
resource "aws_subnet" "private_subnet_1" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1a"
  cidr_block                      = "10.0.4.0/24"
  map_public_ip_on_launch         = "false"

  tags = {
    "Name" = "Private Subnet 1"
  }

}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1b"
  cidr_block                      = "10.0.5.0/24"
  map_public_ip_on_launch         = "false"

  tags = {
    "Name" = "Private Subnet 2"
  }

}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                          = aws_vpc.may_tf.id
  assign_ipv6_address_on_creation = "false"
  availability_zone               = "ap-south-1c"
  cidr_block                      = "10.0.6.0/24"
  map_public_ip_on_launch         = "false"

  tags = {
    "Name" = "Private Subnet 3"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.may_tf.id
  tags = {
    "Name" = "Internet Gateway MAY VPC"
  }
}

# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.may_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Subnet assoication with Route table 
resource "aws_route_table_association" "rt_association_public_subnet_1" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "rt_association_public_subnet_2" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route_table_association" "rt_association_public_subnet_3" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet_3.id
}
