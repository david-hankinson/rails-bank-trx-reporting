# terraform {
#      backend "s3" {
#       bucket         = "rails-bank-trx-reporting"
#        key            = "terraform.tfstate"
#        region         = local.region
#        encrypt        = true
#     }
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#     }
#   }
# }
# module "ecr" {
#   source  = "terraform-aws-modules/ecr/aws"
#   version = "2.3.0"
# }
#
# provider "aws" {
#   region = "ca-central-1"
# }