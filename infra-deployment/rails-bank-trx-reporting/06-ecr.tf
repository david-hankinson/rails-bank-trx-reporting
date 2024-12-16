resource "aws_ecr_repository" "this" {
  name                 = "${var.env}-rails-bank-trx-reporting-ecr-repo"
  image_tag_mutability = "IMMUTABLE"

  tags = {
    Environment = var.env
    Service     = "rails-bank-trx-reporting"
  }
}

resource "aws_iam_role" "ecr_access" {
  name = "${var.env}-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.env
    Service     = "rails-bank-trx-reporting"
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.env}-ecr-policy"
  description = "Policy to allow ECS tasks to access the ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = aws_ecr_repository.this.arn
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attach" {
  role       = aws_iam_role.ecr_access.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}