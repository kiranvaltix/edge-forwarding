resource "aws_subnet" "app" {
  for_each          = var.zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.app_cidr
  availability_zone = each.key

  tags = {
    Name   = "${var.prefix}-app-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table" "app" {
  for_each = var.zones
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-app-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "app" {
  for_each       = var.zones
  subnet_id      = aws_subnet.app[each.key].id
  route_table_id = aws_route_table.app[each.key].id
}

resource "aws_route" "app_default" {
  for_each               = var.zones
  route_table_id         = aws_route_table.app[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
