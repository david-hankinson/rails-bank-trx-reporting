## ECR ##
github_repo = "david-hankinson/rails-bank-trx-reporting" # in the format <github_org>/<github_repo>

## ENVIRONMENT ##
region = "ca-central-1"
env = "prod"

## VPC ##
vpc_cidr_block = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
availability_zones = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
