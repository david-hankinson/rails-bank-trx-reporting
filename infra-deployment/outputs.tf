output "vpc_id" {
  value = module.rails-bank-trx-reporting.vpc_id
}

output "private_subnet_ids" {
  value = module.rails-bank-trx-reporting.private_subnets_ids
}

output "public_subnet_ids" {
  value = module.rails-bank-trx-reporting.public_subnets_ids
}