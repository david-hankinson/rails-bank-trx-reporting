## Get vpc info

data "aws_vpc" "vpc" {
}

## Leave functionality to filter on AZ's/Subnets incase of DR

locals {
  exc_az_zones = []
  #incl_az_zones = ["ca-central-1a","ca-central-1b","ca-central-1d"]
  incl_az_zones = ["ca-central-1a"]
}

data "aws_availability_zones" "available" {
  exclude_names = []
}

data "aws_availability_zones" "unavailable" {
  exclude_names = local.exc_az_zones
}

data "aws_subnets" "available_aws_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "availability-zone"
    values = local.incl_az_zones
  }
}

## End of subnet/vpc filtering