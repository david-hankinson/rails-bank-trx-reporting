terraform {
  source = "../../infra-modules/ecs/"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {
  launch_template_name_prefix = "rails-bank-trx-reporting-prod-asg"
  ec2_image_id = "ami-002e59623e3f8d3f6" # bottlerocket image
  ec2_instance_type = "t2.small"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "rails-bank-trx-reporting-deploy-state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "prod-rails-bank-trx-reporting-deploy"
    key     = "ecs.prod.terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true
  }
}