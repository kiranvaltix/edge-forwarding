resource "aws_subnet" "mgmt" {
  for_each          = var.zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.mgmt_cidr
  availability_zone = each.key

  tags = {
    Name   = "${var.prefix}-mgmt-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table" "mgmt" {
  for_each = var.zones
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-mgmt-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "mgmt" {
  for_each       = var.zones
  subnet_id      = aws_subnet.mgmt[each.key].id
  route_table_id = aws_route_table.mgmt[each.key].id
}

resource "aws_route" "mgmt_default" {
  for_each               = var.zones
  route_table_id         = aws_route_table.mgmt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
