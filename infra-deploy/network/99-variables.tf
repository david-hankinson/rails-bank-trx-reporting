variable "env" {
  d
}
variable "vpc_cidr_block" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "availability_zones" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}

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
  validation {
    condition = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.[a-z0-9][a-z0-9-]{0,61}[a-z0-9]\\.", var.domain_name))
    error_message = "Invalid domain name."}
}

