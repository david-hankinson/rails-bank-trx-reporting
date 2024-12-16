## ECR ##
github_repo = "david-hankinson/rails-bank-trx-reporting" # in the format <github_org>/<github_repo>

## ENVIRONMENT ##
region = "ca-central-1"
env    = "prod"

## VPC ##
vpc_cidr_block     = "10.0.0.0/16"
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
availability_zones = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]

## EC2 ##
instance_type = "t3.micro"
image_id      = "ami-08d658f84a6d84a80"

security_group_rules = [
  {
    name   = "web-sg"
    vpc_id = "vpc-123456"

    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS traffic"
      }
    ]

    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
      }
    ]
  },
  {
    name   = "db-sg"
    vpc_id = "vpc-123456"

    ingress = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
        description = "Allow PostgreSQL traffic"
      }
    ]

    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
      }
    ]
  }
]