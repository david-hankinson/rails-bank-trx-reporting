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
    load_balancer_id = "lb"
    lb_target_group_id = "lb_tg"
  }
}

inputs = {
  ## ec2 inputs
  launch_template_name_prefix = "rails-bank-trx-reporting-prod-asg"
  ec2_image_id = "ami-0a590ca28046d073e" # bottlerocket image
  ec2_instance_type = "t2.medium"
  vpc_zone_identifier = flatten([dependency.network.outputs.public_subnets_ids, dependency.network.outputs.private_subnets_ids])
  security_group_ids = dependency.network.outputs.security_group_ids

  ## ecs inputs
  aws_ecs_cluster_name = "rails-bank-trx-reporting"
  aws_ecs_capacity_provider_name = "rails-bank-trx-reporting-capacity-provider"
  aws_ecs_task_definition_family = "rails-bank-trx-reporting-td-family"
  ecs_minimum_scaling_step_size = 1
  ecs_maximum_scaling_step_size = 2
  ecs_target_capacity_percentage = 80
  aws_ecs_service_subnets = flatten([dependency.network.outputs.public_subnets_ids, dependency.network.outputs.private_subnets_ids])
  aws_ecs_service_security_groups = dependency.network.outputs.security_group_ids
  aws_ecs_service_load_balancer = dependency.network.outputs.load_balancer_id
  aws_ecs_service_load_balancer_tg = dependency.network.outputs.lb_target_group_id
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