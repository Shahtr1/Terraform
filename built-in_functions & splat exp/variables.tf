variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "192.168.0.0/16"
  type        = string
}

variable "web_subnet" {
  description = "Subnet for web apps"
  type        = string
  default     = "192.168.100.0/24"

}

variable "subnet_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "main_vpc_name" {
  type    = string
  default = "Main VPC"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "ami" {
  type = map(string)
  default = {
    "ap-south-1"     = "ami-06791f9213cbb608b"
    "ap-northeast-1" = "ami-0bcf3ca5a6483feba"
    "ap-southeast-1" = "ami-06018068a18569ff2"
    "ap-southeast-2" = "ami-09b402d0a0d6b112b"
  }
}

variable "ssh_public_key" {

}
