terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "shahrukh-master-terraform"
    workspaces {
      name = "DevOps-Production"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "ap-south-1"
  access_key = "**"
  secret_key = "**"
}

# Create an EC2 instance
resource "aws_instance" "server" {
  ami           = "ami-06791f9213cbb608b"
  instance_type = "t2.micro"
}

