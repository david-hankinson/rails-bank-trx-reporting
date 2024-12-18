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

variable "security_group_rules" {
     description = "List of security group configurations"
     type        = list(object({
       name        = string                              # Name of the security group
       vpc_id      = string                              # VPC ID where the security group will be created
       ingress     = list(object({                      # List of ingress rules
         from_port   = number
         to_port     = number
         protocol    = string
         cidr_blocks = list(string)
         description = string
       }))
       egress = list(object({                           # List of egress rules
         from_port   = number
         to_port     = number
         protocol    = string
         cidr_blocks = list(string)
         description = string
       }))
     }))
     default = [] # Provide a default empty list
}

variable "domain_name" {
  description = "Domain name"
  type = string
  default = "bankreporting-app-example.com"
  validation {
    condition = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.[a-z0-9][a-z0-9-]{0,61}[a-z0-9]\\.", var.domain_name))
    error_message = "Invalid domain name."
  }
}

