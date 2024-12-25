terraform {
  source = "."
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "> 4.0"
      }
    }
}
EOF
}

locals {
  region = "ca-central-1"
}

