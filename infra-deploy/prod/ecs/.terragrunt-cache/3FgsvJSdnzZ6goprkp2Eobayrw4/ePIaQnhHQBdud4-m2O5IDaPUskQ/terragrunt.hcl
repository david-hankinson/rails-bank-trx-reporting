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
  config_path = "../network/"

  mock_outputs = {
    public_subnets_ids = ["id_one", "id_two"]
    private_subnets_ids = ["id_one", "id_two"]
    security_group_ids = ["id_one","id_two"]
  }
}

inputs = {
  launch_template_name_prefix = "rails-bank-trx-reporting-prod-asg"
  ec2_image_id = "ami-002e59623e3f8d3f6" # bottlerocket image
  ec2_instance_type = "t2.small"
  vpc_zone_identifier = [dependency.network.outputs.public_subnets_ids[*], dependency.network.outputs.public_subnets_ids[*]]
  security_group_ids = [dependency.network.outputs.security_group_ids[*]]
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