module "vpc" {
  source = "../main"
}


resource "aws_subnet" "public_SB" {
  count = 2
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "public-SB-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "Internet-Gateway"
  }
}

resource "aws_route_table" "webRT" {
  vpc_id = module.vpc.vpc_id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "frontRT"
  }

}


resource "aws_route_table_association" "public_RT_attach" {
  count = 2 
  subnet_id      = aws_subnet.public_SB[count.index].id
  route_table_id = aws_route_table.webRT.id
}


resource "aws_security_group" "web" {
  name        = "WEBSG"
  description = "Allow HTTP(80/tcp, 8080/tcp), SSH(22/tcp)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP(80/tcp)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP(8080/tcp)"
    from_port   = 8080
    to_port     = 8080
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