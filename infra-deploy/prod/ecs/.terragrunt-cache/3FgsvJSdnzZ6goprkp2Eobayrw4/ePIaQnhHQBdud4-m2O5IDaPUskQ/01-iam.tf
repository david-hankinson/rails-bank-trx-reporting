# --- ECS Node Role ---
data "aws_iam_policy_document" "this_ec2_node" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this_ec2_node" {
  name_prefix        = "${var.env}-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.this_ec2_node.json
}

resource "aws_iam_role_policy_attachment" "this_ec2_node" {
  role       = aws_iam_role.this_ec2_node.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "this_ec2_node" {
  name_prefix = "${var.env}-ecs-node-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.this_ec2_node.name
}

# --- ECS Task Role ---
data "aws_iam_policy_document" "this_ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this_ecs_task" {
  name_prefix        = "demo-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.this_ecs_task.json
}

resource "aws_iam_role" "this" {
  name_prefix        = "demo-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.this_ecs_task.json
}

resource "aws_iam_role_policy_attachment" "this_ecs_task" {
  role       = aws_iam_role.this_ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}