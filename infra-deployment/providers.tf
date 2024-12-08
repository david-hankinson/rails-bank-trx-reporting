terraform {
     backend "s3" {
      bucket         = "rails-bank-trx-reporting"
       key            = "terraform.tfstate"
       # region         = local.region
       encrypt        = true
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}