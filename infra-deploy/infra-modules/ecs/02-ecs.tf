# Create an ECS cluster
resource "aws_ecs_cluster" "this" {
  name = var.aws_ecs_cluster_name

  depends_on = [aws_autoscaling_group.this]
}

resource "aws_ecs_capacity_provider" "this" {
  name = var.aws_ecs_capacity_provider_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this.arn

    managed_scaling {
      maximum_scaling_step_size = var.ecs_maximum_capacity_provider_maximum_scaling_step_size
      minimum_scaling_step_size = var.ecs_minimum_capacity_provider_maximum_scaling_step_size
      status                    = "ENABLED" # Hardcoded as an opinionated standard
      target_capacity           = var.ecs_target_capacity_percentage
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1 # Minimum number of tasks to run on this capacity provider
    weight            = 100 # Makes this provider the default, 100% of tasks will be hosted here
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}

# Define the ECS task definition for the service
resource "aws_ecs_task_definition" "this" {
  family             = var.aws_ecs_task_definition_family
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::532199187081:role/ecsTaskExecutionRole"
  cpu                = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = "public.ecr.aws/f9n5f1l7/dgs:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.security_group.id]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "dockergs"
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}
