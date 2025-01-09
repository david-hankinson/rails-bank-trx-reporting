variable "env" {
  description = "Which environment the infrastructure will be deployed in"
  type = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type = string
}
variable "private_subnets" {
  description = "List of private subnets"
  type = list(string)
}
variable "public_subnets" {
  description = "List of public subnets"
  type = list(string)
}
variable "availability_zones" {
  description = "List of availability zones"
  type = list(string)
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type = bool
}
variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type = bool
}


# variable "domain_name" {
#   type = string
#   default = "http://bankreporting-app-example.com/"
#   validation {
#     condition     = can(regex("^[a-zA-Z0-9-]+\\.[a-zA-Z]+$", var.domain_name))
#     error_message = "The domain name must follow a valid pattern (e.g., example.com)."
#   }
# }

# variable "security_group_rules" {
#   type = list(object({
#     name       = string
#     ingress    = list(object({
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       cidr_blocks = list(string)
#       description = string
#     }))
#     egress     = list(object({
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       cidr_blocks = list(string)
#       description = string
#     }))
#   }))
#   default = [] # Empty list to prevent errors when unused
# }
#
# variable "security_groups" {
#   type = map(object({
#     description = string
#     tags        = map(string)
#   }))
#   description = "Map of security group configurations"
# }
