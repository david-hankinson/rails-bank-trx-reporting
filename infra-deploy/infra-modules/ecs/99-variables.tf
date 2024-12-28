variable "launch_template_name_prefix" {
  type = string
  description = "launch template name prefix"
}

variable "ec2_image_id" {
  type        = string
  description = "ec2 image id"
}

variable "ec2_instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "vpc_zone_identifier" {
  type = list(string)
  description = "vpc zone identifiers"
}

variable "security_group_ids" {
  type = list(string)
  description = "security_group_ids"
}

variable "aws_ecs_cluster_name" {
  type = string
  description = "aws ecs cluster name"
}

variable "aws_ecs_capacity_provider_name" {
  type = string
  description = "aws ecs capacity provider name"
}

variable "aws_ecs_task_definition_family" {
  type = string
  description = "aws ecs task definition"
}

variable "ecs_maximum_capacity_provider_maximum_scaling_step_size" {
  type = number
  description = "ecs maximum capacity provider maximum scaling step size"
}

variable "ecs_minimum_capacity_provider_maximum_scaling_step_size" {
  type = number
  description = "ecs minimum capacity provider minimum scaling step size"
}

variable "ecs_target_capacity_percentage" {
  type = number
  description = "ecs target capacity percentage"
}

variable "aws_ecs_service_subnets" {
  type = list(string)
  description = "aws ecs service subnets"
}

variable "aws_ecs_service_security_groups" {
  type = list(string)
  description = "aws ecs service security groups"
}

variable "aws_ecs_service_load_balancer" {
  type = string
  description = "aws ecs service load balancer"
}


