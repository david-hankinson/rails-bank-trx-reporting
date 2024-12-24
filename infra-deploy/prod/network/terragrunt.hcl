terraform {
  source = "../../infra-modules/network/"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  # Environment
  region                   = include.root.locals.region
  availability_zones       = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]

  # VPC Configuration
  vpc_cidr_block           = "10.0.0.0/16"
  enable_dns_support       = true
  enable_dns_hostnames     = true

  # Subnet Configuration
  public_subnets           = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets          = ["10.0.3.0/24", "10.0.4.0/24"]
  database_subnets         = ["10.0.5.0/24", "10.0.6.0/24"]

  # Security Groups
  allowed_ssh_cidr_blocks  = ["192.168.1.0/24"]         # Restrict SSH
  alb_ingress_ports        = [80, 443]                 # Allow HTTP/HTTPS traffic
  app_ingress_ports        = [80, 443]                 # Allow HTTP to application servers

  # Domain Configuration
  domain_name              = "bankreporting-app-example.com"  # Default domain name for the app

  # Security Group Rules
  security_group_rules = [
    {
      name       = "alb-sg"
      ingress    = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTP traffic"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTPS traffic"
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1" # Allow all protocols
          cidr_blocks = ["0.0.0.0/0"]
          description = "Outbound traffic allowed"
        }
      ]
    },
    {
      name       = "app-sg"
      ingress    = [
        {
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "Allow traffic to app servers"
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Outbound traffic allowed"
        }
      ]
    }
  ]

  # Security Group Definitions
  security_groups = {
    "alb-sg" = {
      description = "ALB security group"
      tags        = {
        Name = "alb-sg"
        Env  = "dev"
      }
    }
    "app-sg" = {
      description = "Application security group"
      tags        = {
        Name = "app-sg"
        Env  = "dev"
      }
    }
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "rails-bank-trx-reporting-deploy-state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "prod-rails-bank-trx-reporting-deploy"
    key     = "ecr.terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true
  }
}