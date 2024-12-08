resource "aws_ecr_repository" "rails-bank-trx-reporting" {
  name = "rails-bank-trx-reporting"
  repository_name = "rails-bank-trx-reporting"
}

output "repository_url" {
  value = aws_ecr_repository.hello_world_repo.repository_url
}