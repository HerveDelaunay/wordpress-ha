# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create the subnets
# Public auto allocates public ipv4 address
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_public_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone = var.az_a

  tags = {
    Name = "public-a"
    Environment = var.environment
    Owner = "hde"
  }

  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_public_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone = var.az_b

  tags = {
    Name = "public-b"
    Environment = var.environment
    Owner = "hde"
  }

  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_private_subnet_a
  availability_zone = var.az_a

  tags = {
    Name = "private-a"
    Environment = var.environment
    Owner = "hde"
  }

  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_private_subnet_b
  availability_zone = var.az_b

  tags = {
    Name = "private-b"
    Environment = var.environment
    Owner = "hde"
  }

  depends_on = [ aws_vpc.main ]
}

#IGW for the VPC
resource "aws_internet_gateway" "igateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igateway"
    Owner = "hde"
  }

  depends_on = [aws_vpc.main]
}

# Routing table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-routetable"
  }

  depends_on = [aws_vpc.main]
}

# Route to the IGW
resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igateway.id

  depends_on = [aws_internet_gateway.igateway]
}

# Link public subnet a to public routing table
resource "aws_route_table_association" "rtb_association_a" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

# Link public subnet b to public routing table
resource "aws_route_table_association" "rtb_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

# NAT
resource "aws_eip" "eip_public_a" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_a" {
  # allocate an elastic ip
  allocation_id = aws_eip.eip_public_a.id
  # attach to the public subnet a
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "hde-nat-public-a"
  }
}

resource "aws_eip" "eip_public_b" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  # attach to the public subnet b
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "hde-nat-public-b"
  }
}