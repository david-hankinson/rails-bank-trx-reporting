terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
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