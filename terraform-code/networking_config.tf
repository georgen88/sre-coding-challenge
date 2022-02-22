resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block-vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public-subnet" {
  depends_on = [aws_vpc.vpc]
  availability_zone           = "us-east-1b"
  cidr_block              = var.cidr_block-subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr-open
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route.id
}


