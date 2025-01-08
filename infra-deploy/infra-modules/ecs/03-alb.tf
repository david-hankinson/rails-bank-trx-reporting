resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id] #  # ALB security groups
  subnets            = var.public_subnet_ids       # Use public subnets

  enable_deletion_protection = false
  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.env}-tg"
  target_type = "ip"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
  enabled             = true
    path                = "/"
    port                = 8080
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.env}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# resource "aws_eip" "this" {
#   for_each = { for idx, subnet_id in aws_subnet.public[*].id : idx => subnet_id }
#   depends_on = [aws_internet_gateway.this]
#   tags       = { Name = "${var.env}-eip" }
# }

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gw_id
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = { for idx, subnet_id in var.public_subnet_ids : idx => subnet_id }

  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}