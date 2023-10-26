variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "CIDR Block for the VPC"
  type        = string
}

variable "web_subnet" {
  default     = "10.0.10.0/24"
  description = "Web Subnet"
  type        = string
}

variable "aws_region" {

}

variable "subnet_zone" {
  # getting this from env variable TF_VAR_subnet_zone
  # export TF_VAR_subnet_zone="ap-south-1b"
}

variable "main_vpc_name" {

}

variable "my_public_ip" {

}

variable "ssh_public_key" {

}
