output "vpc_id" {
  value       = aws_vpc.main.id
  description = "Outputs the unique VPC identifier"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet.*.id
  description = "Outputs the public subnet identifiers"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet.*.id
  description = "Outputs the private subnet identifiers"
}
