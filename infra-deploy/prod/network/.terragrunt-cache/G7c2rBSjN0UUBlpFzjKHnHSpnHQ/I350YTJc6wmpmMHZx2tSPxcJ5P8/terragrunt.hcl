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
  env                      = include.env.locals.env
  region                   = include.env.locals.region
  availability_zones       = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]

  # VPC Configuration
  vpc_cidr_block           = "10.0.0.0/16"
  enable_dns_support       = true
  enable_dns_hostnames     = true

  # Subnet Configuration
  public_subnets           = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets          = ["10.0.3.0/24", "10.0.4.0/24"]

  # Security Groups
  allowed_ssh_cidr_blocks  = ["192.168.1.0/24"]         # Restrict SSH
  alb_ingress_ports        = [80, 443]                 # Allow HTTP/HTTPS traffic
  app_ingress_ports        = [80, 443]                 # Allow HTTP to application servers
}

remote_state {
  backend = "s3"
  generate = {
    path      = "rails-bank-trx-reporting-deploy-state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "prod-rails-bank-trx-reporting-deploy"
    key     = "network.prod.terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true
  }
}