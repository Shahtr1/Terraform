output "main_vpc_id" {
  value = aws_vpc.main.id
}

output "web_subnet_id" {
  value = aws_subnet.web.id
}
