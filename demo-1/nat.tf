resource "aws_eip" "eip_web" {
  vpc = "true"

  tags = {
    "Name" = "Elastic IP Address AWS"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_web.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    "Name" = "NAT GATEWAY"
  }
}

# Private route table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.may_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}


# Private subnet association
resource "aws_route_table_association" "rt_association_private_subnet_1" {
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "rt_association_private_subnet_2" {
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet_2.id
}

resource "aws_route_table_association" "rt_association_private_subnet_3" {
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet_3.id
}
