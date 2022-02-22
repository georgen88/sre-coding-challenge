
resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  availability_zone           = "us-east-1b"
  user_data                   = <<-EOF
                                    #!/bin/bash
                                    yum update -y
                                    yum install -y httpd
                                    systemctl start httpd
                                    systemctl enable httpd
                                    echo " Webserver for challenge" > /var/www/html/index.html
                                EOF
  tags                        = local.tags
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr-open]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.cidr-open]
  }
}