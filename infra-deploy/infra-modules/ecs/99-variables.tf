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

