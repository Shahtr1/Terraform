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
  region     = var.aws_region
  access_key = "**"
  secret_key = "**"
}

# resource "<provider>_<resource_type>" "local_name"{
#     argument1 = value1
#     argument2 = value2
#     ...
# }

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Production VPC."
  }

  enable_dns_support = var.enable_dns
}

# Create a subnet
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.azs[2]
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
    cidr_block = "0.0.0.0/0" # All traffic which is not local will be handled by the internet gateway
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
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = var.egress_dsg["from_port"]
    to_port         = var.egress_dsg["to_port"]
    protocol        = var.egress_dsg["protocol"]
    cidr_blocks     = var.egress_dsg["cidr_blocks"]
    prefix_list_ids = []
  }

  tags = {
    "Name" = "Default Security Group"
  }


}

resource "aws_instance" "server" {
  ami           = var.amis[var.aws_region]
  instance_type = var.my_instance[0]
  # cpu_core_count              = var.my_instance[1]
  associate_public_ip_address = var.my_instance[2]

  count = 1

  tags = {
    "Name" = "Amazon Linux 2"
  }
}

# resource "aws_iam_user" "test" {
#   name  = "x-user${count.index}"
#   path  = "/system/"
#   count = 5
# }


# resource "aws_iam_user" "test" {
#   name  = element(var.users, count.index)
#   path  = "/system/"
#   count = length(var.users)
# }

# when we use count it means resources are ordered, removing one in the middle causes all resources to shift to new positions
/*
  Error: updating IAM User (admin1): EntityAlreadyExists: User with name john already exists.
│       status code: 409, request id: 44a6c48d-1a42-492a-854e-6506c96d2e81
*/
# so we should use for_each, they provide maps or sets, and maps and sets are unordered

resource "aws_iam_user" "test" {
  for_each = toset(var.users)
  name     = each.key
}
