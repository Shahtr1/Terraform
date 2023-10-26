terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "ap-south-1"
  access_key = "**"
  secret_key = "**"
}



# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Production VPC."
  }

}

# Create a subnet
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "Web subnet"
  }
}

# Connectivity to the internet
resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" = "Web Internet Gateway"
  }
}

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }

  tags = {
    "Name" = "my-default-rt"
  }
}

# configure default security group of a VPC
resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Default Security Group"
  }


}



resource "aws_instance" "testing-server" {
  ami           = "ami-06791f9213cbb608b"
  instance_type = "t2.micro"
  count         = var.isTest == true ? 1 : 0
}

resource "aws_instance" "prod-server" {
  ami           = "ami-06791f9213cbb608b"
  instance_type = "t2.large"                  # is not eligible for free-teir
  count         = var.isTest == false ? 1 : 0 # resource will not be created
}
