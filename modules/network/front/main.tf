resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_subnet" "public_SB_1" {
  vpc_id     = var.vpc_id
  availability_zone = "ap-northeast-2a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-SB-1"
  }
}

resource "aws_subnet" "public_SB_2" {
  vpc_id     = var.vpc_id
  availability_zone = "ap-northeast-2c"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-SB-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Internet-Gateway"
  }
}


resource "aws_default_route_table" "webRT" {
  default_route_table_id = var.default_RT


  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "frontRT"
  }

}


resource "aws_route_table_association" "public_RT_attach-1" {
  subnet_id      = aws_subnet.public_SB_1.id
  route_table_id = aws_default_route_table.webRT.id
}

resource "aws_route_table_association" "public_RT_attach-2" {
  subnet_id      = aws_subnet.public_SB_2.id
  route_table_id = aws_default_route_table.webRT.id
}

resource "aws_security_group" "web" {
  name        = "WEBSG"
  description = "Allow HTTP(80/tcp, 8080/tcp), SSH(22/tcp)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP(80/tcp)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH(22/tcp)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WEBSG"
  }
}