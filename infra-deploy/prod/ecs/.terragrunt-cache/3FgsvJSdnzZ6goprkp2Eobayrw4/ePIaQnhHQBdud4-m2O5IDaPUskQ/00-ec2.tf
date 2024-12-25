resource "aws_launch_template" "this" {
  name_prefix   = "${var.launch_template_name_prefix}-ec2-lt"
  image_id      = var.ec2_image_id
  instance_type = var.ec2_instance_type

  # key_name               = "ec2ecsglog"
  vpc_security_group_ids = var.security_group_ids
  # iam_instance_profile {
  #   name = #TODO
  # }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  # user_data = filebase64("./ecs.sh")

}

resource "aws_autoscaling_group" "this" {
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}




