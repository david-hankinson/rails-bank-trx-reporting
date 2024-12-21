module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  # Repository Configuration
  name                                = "${var.repository_name}-${var.env}}" # The name of the ECR repository
  # image_tag_mutability                = "MUTABLE"        # Allows mutability for tags (can be changed to IMMUTABLE if strict tagging is required)
  repository_policy_text              = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "AllowPushPullFromSameAccount"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"  # Allow only this AWS account to access the ECR
        }
        Action    = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      }
    ]
  })

  # Lifecycle Policies
  # This will clean up images that are untagged to free up storage space.
  image_scanning_configuration        = {
    scan_on_push = true # Enable automatic scanning of images for vulnerabilities on upload
  }
  lifecycle_policy                    = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 30 days"
        selection    = {
          tagStatus = "untagged"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 30
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })

  # Tags for Better Traceability
  tags = {
    Environment = "dev"
    Application = "my-app"
  }
}

locals {
  account_id = "123456789012" # Replace with your actual AWS account ID
}
}