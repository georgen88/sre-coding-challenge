resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public-subnet" {
  depends_on = [aws_vpc.vpc]

  cidr_block              = "10.0.1.0/24"
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
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_instance" "instance" {
  ami                         = "ami-09d95fab7fff3776c"
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = <<-EOF
                                    #!/bin/bash
                                    yum update -y
                                    yum install -y httpd
                                    systemctl start httpd
                                    systemctl enable httpd
                                    echo " Webserver for challenge" > /var/www/html/index.html
                                EOF


  tags = local.tags
}


resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}

