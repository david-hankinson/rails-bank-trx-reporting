### START OF CONFIGURATION FOR ECR IAM RESOURCES ###

resource "aws_iam_role" "github_action_to_ecr_role" {
  name = "github_action_to_ecr_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${github_repo}:*"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ecr_github_actions" {
  name        = "ecr_github_actions_policy"
  description = "GitHub Actions access to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories", # Allows listing repositories
          "ecr:ListImages", # Allows listing images
          "ecr:DeleteImages", # Allows deleting images (use with caution!)
        ],
        Effect   = "Allow",
        Resource = "*", # Or restrict to specific repositories if needed (see below)
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_github_actions" {
  role       = aws_iam_role.github_action_to_ecr_role.name
  policy_arn = aws_iam_policy.ecr_github_actions.arn
}
