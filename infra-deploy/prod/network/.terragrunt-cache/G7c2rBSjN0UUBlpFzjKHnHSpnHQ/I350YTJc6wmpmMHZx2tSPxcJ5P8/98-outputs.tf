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
  value = [aws_security_group.this.id]
}

output "load_balancer_id" {
  value = aws_lb.this.arn
}

output "lb_target_group_id" {
  value = aws_lb_target_group.this.id
}

output "alb_url" {
  value = aws_lb.this.dns_name
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}