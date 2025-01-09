output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "internet_gw_id" {
  value = aws_internet_gateway.this.id
}

output "vpc_sg" {
  value = aws_security_group.this.id
}