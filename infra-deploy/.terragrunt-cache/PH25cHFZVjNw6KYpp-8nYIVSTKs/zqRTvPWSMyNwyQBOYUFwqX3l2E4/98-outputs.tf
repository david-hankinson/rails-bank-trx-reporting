output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "security_group_ids" {
  value = [for sg in aws_security_group.this : sg.id]
}