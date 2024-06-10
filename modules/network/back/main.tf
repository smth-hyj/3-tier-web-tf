resource "aws_subnet" "private_SB_1" {
  vpc_id     = var.vpc_id
  availability_zone = "ap-northeast-2a"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private_SB_back-1"
  }
}

resource "aws_subnet" "private_SB_2" {
  vpc_id     = var.vpc_id
  availability_zone = "ap-northeast-2c"
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private_SB_back-2"
  }
}

resource "aws_nat_gateway" "back_gw_1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_SB_1.id 
}

resource "aws_nat_gateway" "back_gw_2" {
  connectivity_type = "private"
  subnet_id = aws_subnet.private_SB_2.id
}

resource "aws_route_table" "back-end" {
  vpc_id = var.vpc_id

  route {
    cidr_block = aws_subnet.private_SB_1.cidr_block
    gateway_id = aws_nat_gateway.back_gw_1.id
  }

  route {
    cidr_block = aws_subnet.private_SB_2.cidr_block
    gateway_id = aws_nat_gateway.back_gw_2.id
  }

  tags = {
    Name = "back-end-RT"
  }
}

resource "aws_route_table_association" "private_RT_attach1" {
  subnet_id = aws_subnet.private_SB_1.id
  route_table_id = aws_route_table.back-end.id
}
resource "aws_route_table_association" "private_RT_attach2" {
  subnet_id = aws_subnet.private_SB_2.id
  route_table_id = aws_route_table.back-end.id
}

resource "aws_security_group" "app" {
  name        = "APPSG"
  description = "Allow Traffic in Application"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP(80/tcp)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_cidrs
  }

  ingress {
    description = "Allow SSH(22/tcp)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_cidrs
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_cidrs
  }

  egress {
    description = "Allow SSH(22/tcp)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_cidrs
  }

  tags = {
    Name = "APPSG"
  }
}