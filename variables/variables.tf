variable "web_port" {
  description = "Web Port"
  default     = 80
  type        = number
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "enable_dns" {
  description = "DNS Support for the VPC"
  type        = bool
  default     = true
}

variable "azs" {
  description = "AZs (Availability Zones) in the Region"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

# type map
variable "amis" {
  type = map(string)
  default = {
    "ap-south-1"     = "ami-06791f9213cbb608b",
    "ap-northeast-1" = "ami-0bcf3ca5a6483feba",
  }
}

variable "my_instance" {
  type    = tuple([string, number, bool])
  default = ["t2.micro", 1, true]
}

variable "egress_dsg" {
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0
    to_port     = 65365,
    protocol    = "tcp"
    cidr_blocks = ["100.0.0.0/16", "200.0.0.0/16"]
  }
}

variable "users" {
  type    = list(string)
  default = ["demo-user", "john"]
}
