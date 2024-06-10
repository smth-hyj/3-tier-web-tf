terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}


module "web" {
  source = "../3-tier/front"
  vpc_id = aws_vpc.main.id
  default_RT =  aws_vpc.main.default_route_table_id
}

module "app" {
  source = "../3-tier/back"
  vpc_id = aws_vpc.main.id
  public_cidrs = module.web.Public_cidr_blocks
  webSGid = module.web.frontSG
  webSBids = [module.web.public_SB_id1, module.web.public_SB_id2]

}
