  # resource "aws_security_group" "this" {
  #    for_each = { for sg in var.security_group_rules : sg.name => sg }
  #
  #    name   = each.value.name
  #    vpc_id = each.value.vpc_id
  #
  #    tags = {
  #      Name = each.value.name
  #    }
  #  }

resource "aws_security_group" "this" {
  for_each    = var.security_groups # Ensure this is a map or set of strings
  name        = each.key
  description = "Managed by Terraform"
  vpc_id      = aws_vpc.this.id
}