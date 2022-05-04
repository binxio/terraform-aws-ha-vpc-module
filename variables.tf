variable "cidr_block" {
  type        = string
  description = "Classless Inter-Domain Routing (CIDR) block"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags that will be applied to all resources"
}

variable "subnet_newbits" {
  type        = string
  description = "Subnet mask bits"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support"
}
