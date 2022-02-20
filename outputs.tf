output "vpc_id" {
  value       = aws_vpc.main.id
  description = "Outputs the unique VPC identifier"
}
