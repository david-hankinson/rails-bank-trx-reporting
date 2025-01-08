resource "aws_launch_template" "this" {
  name_prefix            = "${var.env}-ecs-node-lt-"
  image_id               = var.ec2_image_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config;
    EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.env}-ecs-asg"
  vpc_zone_identifier       = var.public_subnet_ids
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_alb_target_group_attachment" "this" {
  target_group_arn       = aws_lb_target_group.this.arn
  target_id              = [aws_autoscaling_group.this.ip]
}



