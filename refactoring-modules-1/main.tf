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
  region     = var.region
  access_key = "**"
  secret_key = "**"
}

module "vpc" {
  source = "../modules/vpc"
}

module "server" {
  source      = "../modules/server"
  vpc_id      = module.vpc.main_vpc_id
  subnet_id   = module.vpc.web_subnet_id
  server_type = var.server_type
  public_key  = var.public_key
  script_name = var.script_name
}
