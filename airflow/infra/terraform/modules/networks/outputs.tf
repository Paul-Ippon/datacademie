output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC's id"
}

output "public_subnets_ids" {
  value       = aws_subnet.public_subnets.*.id
  description = "IDs of the public subnets."
}

output "private_subnets_ids" {
  value       = aws_subnet.private_subnets.*.id
  description = "IDs of the private subnets."
}