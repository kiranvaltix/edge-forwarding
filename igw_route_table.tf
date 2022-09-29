resource "aws_route_table" "igw" {
  for_each = var.zones
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-igw-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "igw" {
  for_each       = var.zones
  route_table_id = aws_route_table.igw[each.key].id
  gateway_id     = aws_internet_gateway.igw.id
}

