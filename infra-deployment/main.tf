resource "aws_ecr_repository" "hello_world_repo" {
  name = "hello-world-repo"
}

output "repository_url" {
  value = aws_ecr_repository.hello_world_repo.repository_url
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    backend "s3" {
      bucket         = "rails-bank-trx-reporting"
       key            = "terraform.tfstate"
       region         = local.region
       encrypt        = true
    }

  }
}
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"
}

provider "aws" {
  region = "ca-central-1"
}