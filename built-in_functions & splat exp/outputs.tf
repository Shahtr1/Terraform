
output "ec2_public_ips" {
  value       = aws_instance.my_vm[*].public_ip
  description = "The public IP of the EC2 instance"
}

output "ami_ids" {
  description = "The ID of the AMI"
  value       = aws_instance.my_vm[*].ami
}

output "Datetime" {
  description = "Current Data and Time"
  value       = local.time
}

# output "private_address" {
#   value = aws_instance.my_vm[0].private_ip
# }

output "private_addresses" {
  value = aws_instance.my_vm[*].private_ip
}
