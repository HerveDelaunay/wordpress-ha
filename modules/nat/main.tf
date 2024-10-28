# public subnet a NAT gateway
resource "aws_eip" "eip_public_a" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_public_a" {
  allocation_id = aws_eip.eip_public_a.id
  subnet_id     = var.public_subnet_id_a

  tags = {
    Name = "hde-nat-public-a"
  }
}

resource "aws_route_table" "rtb_private_subnet_a" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "hde-privatea-routetable"
  }
}

resource "aws_route" "route_nat_private_a" {
  route_table_id         = aws_route_table.rtb_private_subnet_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw_public_a.id
}

resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = var.private_subnet_id_a
  route_table_id = aws_route_table.rtb_private_subnet_a.id
}

# public subnet b NAT gateway
resource "aws_eip" "eip_public_b" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  subnet_id     = var.public_subnet_id_b

  tags = {
    Name = "hde-nat-public-b"
  }
}

resource "aws_route_table" "rtb_private_subnet_b" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "hde-privateb-routetable"
  }
}

resource "aws_route" "route_nat_private_b" {
  route_table_id         = aws_route_table.rtb_private_subnet_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw_public_b.id
}

resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = var.private_subnet_id_b
  route_table_id = aws_route_table.rtb_private_subnet_b.id
}