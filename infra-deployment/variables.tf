variable "github_repo" {}

variable "env" {
  description = "The environment to deploy to"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type = string
}

variable "availability_zones" {
  description = "AZ's for subnets"
  type = list(string)
}

variable "region" {
  description = "AWS region"
  type = string
}

variable "private_subnets" {
  description = "Private subnets"
  type = list(string)
}

variable "public_subnets" {
  description = "Public subnets"
  type = list(string)
}