  resource "aws_security_group" "this" {
     for_each = { for sg in var.security_group_rules : sg.name => sg }

     name   = each.value.name
     vpc_id = each.value.vpc_id

     tags = {
       Name = each.value.name
     }
   }

   resource "aws_security_group_rule" "ingress" {
     for_each = flatten([
       for sg in var.security_group_rules : [
         for rule in sg.ingress : {
           sg_name       = sg.name
           from_port     = rule.from_port
           to_port       = rule.to_port
           protocol      = rule.protocol
           cidr_blocks   = rule.cidr_blocks
           description   = rule.description
         }
       ]
     ])

     type              = "ingress"
     security_group_id = aws_security_group.this[each.value.sg_name].id
     from_port         = each.value.from_port
     to_port           = each.value.to_port
     protocol          = each.value.protocol
     cidr_blocks       = each.value.cidr_blocks
     description       = each.value.description
   }

   resource "aws_security_group_rule" "egress" {
     for_each = flatten([
       for sg in var.security_group_rules : [
         for rule in sg.egress : {
           sg_name       = sg.name
           from_port     = rule.from_port
           to_port       = rule.to_port
           protocol      = rule.protocol
           cidr_blocks   = rule.cidr_blocks
           description   = rule.description
         }
       ]
     ])

     type              = "egress"
     security_group_id = aws_security_group.this[each.value.sg_name].id
     from_port         = each.value.from_port
     to_port           = each.value.to_port
     protocol          = each.value.protocol
     cidr_blocks       = each.value.cidr_blocks
     description       = each.value.description
   }