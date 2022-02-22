resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet" {
  depends_on = [aws_vpc.vpc]

  cidr_block              = "10.0.0.0/16"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_route_table" "route-table" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_route_table_association" "rt-association" {
  depends_on     = [aws_route_table.route-table, aws_subnet.subnet]
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_route" "public_route" {
  depends_on             = [aws_route_table.route-table, aws_internet_gateway.igw]
  route_table_id         = aws_route_table.route-table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


