resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name   = "${var.prefix}-vpc"
    prefix = var.prefix
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-vpc"
    prefix = var.prefix
  }
}
