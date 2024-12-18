terraform {
  source = "./network"
}

inputs = {
  # Environment
  env                      = "dev"
  region                   = "ca-central-1"
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
  allowed_ssh_cidr_blocks  = ["192.168.1.0/24"] # Restrict SSH
  alb_ingress_ports        = [80, 443]          # Allow HTTP/HTTPS traffic
  app_ingress_ports        = [80, 443]              # Allow HTTP to application servers
}