module "rails-bank-trx-reporting" {
  source = "./rails-bank-trx-reporting"

  # VPC Vars
  env                = var.env
  vpc_cidr_block     = var.vpc_cidr_block
  private_subnets    = var.public_subnets
  public_subnets     = var.private_subnets
  availability_zones = var.availability_zones

  # EC2 Vars
  image_id      = var.image_id
  instance_type = var.instance_type
}


