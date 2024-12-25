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