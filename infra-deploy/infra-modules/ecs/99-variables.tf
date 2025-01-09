variable "env" {
  description = "Which environment the infrastructure will be deployed in"
  type = string
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "public subnet ids"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "private subnet ids"
}

variable "ec2_instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "vpc_zone_identifier" {
  type = list(string)
  description = "vpc zone identifiers"
}

variable "vpc_security_group_ids" {
  type = string
  description = "vpc security group ids"
}

variable "aws_ecs_cluster_name" {
  type = string
  description = "aws ecs cluster name"
}

variable "domain_name" {
  type = string
  description = "domain name"
}

variable "internet_gw_id" {
  type = string
  description = "internet gw id"
}

variable "ec2_image_id" {
  type = string
  description = "ec2 image id"
}
