# Create an ECS cluster
resource "aws_ecs_cluster" "this" {
  name = var.aws_ecs_cluster_name

  #depends_on = [aws_autoscaling_group.this]
}


resource "aws_ecs_capacity_provider" "this" {
  name = "${var.env}-rails-bank-trx-fargate-cp" # Name for Fargate capacity provider

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn # Reference to the ASG you created
    managed_scaling {
      status                  = "ENABLED"
      target_capacity         = 90     # Target utilization percentage for scaling
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10
    }
    managed_termination_protection = "ENABLED" # Enable or disable instance termination protection
  }
  # Fargate Spot is optional, but can be included based on your requirements
  tags = {
    Name = "${var.env}-rails-bank-trx-fargate-cp"
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
  family                   = "nginx"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name        = "nginx",
      image       = "nginx:latest",
      memory      = 256,
      cpu         = 256,
      essential   = true,
      portMappings = [
        {
          containerPort = 8080,
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
  name            = "${var.env}rails-bank-trx-reporting-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.this.id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_autoscaling_group.this.id
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
    container_port = 8080
  }
}
