output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.roey_pf_vpc.id
}

output "subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.private_subnet.*.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
