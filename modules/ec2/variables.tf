variable "ami_id" {
  description = "AMI ID to provision"
  type        = string
  default     = "ami-06791f9213cbb608b"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "servers" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}
