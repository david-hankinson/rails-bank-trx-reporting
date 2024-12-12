module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  repository_name = "rails-bank-trx-reporting"
}