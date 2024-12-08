resource "aws_ecr_repository" "hello_world_repo" {
  name = "hello-world-repo"

}

output "repository_url" {
  value = aws_ecr_repository.hello_world_repo.repository_url
}