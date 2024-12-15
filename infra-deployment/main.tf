module "vpc" {
  source = "./rails-bank-vpc"

  # Variable values passed by var file
  env = var.env
  vpc_cidr_block = var.vpc_cidr_block
  private_subnets = var.public_subnets
  public_subnets = var.private_subnets
  availability_zones = var.availability_zones
}


