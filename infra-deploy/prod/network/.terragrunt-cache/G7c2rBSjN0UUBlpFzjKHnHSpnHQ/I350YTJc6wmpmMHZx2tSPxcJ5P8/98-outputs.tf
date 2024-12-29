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

output "load_balancer_id" {
  value = aws_lb.this.arn
}

output "lb_target_group_id" {
  value = aws_lb_target_group.this.id
}