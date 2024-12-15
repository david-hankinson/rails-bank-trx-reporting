 provider "aws" {
  region = "ca-central-1"
}

terraform {
     backend "s3" {
      bucket         = "rails-bank-trx-reporting"
       key            = "terraform.tfstate"
       region         = "ca-central-1"
       encrypt        = true
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

