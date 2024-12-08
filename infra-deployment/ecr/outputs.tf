# Output the EKS cluster details
output "cluster_name" {
  value = var.eks_cluster_name
}

output "vpc_cidr_block" {
  value = data.aws_vpc.vpc.cidr_block
}

output "vpc_subnets" {
  value = [data.aws_subnets.available_aws_subnets.*.ids]
}