resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

# Public Subnet Associations
resource "aws_route_table_association" "public_subnet_associations" {
  for_each = { for index, subnet in aws_subnet.public : index => subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.route_table.id
}

# Private Subnet Associations (if required)
resource "aws_route_table_association" "private_subnet_associations" {
  for_each = { for index, subnet in aws_subnet.private : index => subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.route_table.id
}