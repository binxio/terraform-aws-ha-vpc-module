variable "cidr" {
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
