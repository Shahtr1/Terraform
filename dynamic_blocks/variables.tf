variable "ingress_ports" {
  description = "List of ingress Ports"
  type        = list(number)
  default     = [22, 80, 110, 143, 443, 993, 8080]
}
