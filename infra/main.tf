terraform {
  required_version = "1.10.1"
}

output "helloworld" {
  description =         "Helloworld"
  value       = "Helloworld"
}

resource "aws_instance" "foo" {
  instance_type = "t1.2xlarge"
}