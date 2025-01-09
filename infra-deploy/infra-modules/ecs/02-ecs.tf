# Create an ECS cluster
resource "aws_ecs_cluster" "this" {
  name = "my-ecs-cluster"

  #depends_on = [aws_autoscaling_group.this]
}

resource "aws_ecs_capacity_provider" "this" {
  name = "${var.env}-rails-bank-trx-ecs-ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }
}

# Define the ECS task definition for the service
resource "aws_ecs_task_definition" "this" {
  family             = "${var.env}-rails-bank-trx-reporting"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_node_role.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([
    {
      name        = "nginx",
      image       = "nginx:latest",
      memory      = 256,
      cpu         = 256,
      essential   = true,
      portMappings = [
        {
          containerPort = 80,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.id
          awslogs-region        = "ca-central-1",
          awslogs-stream-prefix = "nginx-"
        }
      }
    }
  ])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "this" {
  name            = "${var.env}-rails-bank-trx-reporting-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.this.id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name = "nginx"
    container_port = 80
  }
}

# resource "aws_nat_gateway" "this" {
#   count = length(var.public_subnet_ids)
#   connectivity_type = "public"
#   subnet_id = var.public_subnet_ids[count.index]
# }