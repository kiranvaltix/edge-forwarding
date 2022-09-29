resource "aws_subnet" "datapath" {
  for_each          = var.zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.datapath_cidr
  availability_zone = each.key

  tags = {
    Name   = "${var.prefix}-datapath-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table" "datapath" {
  for_each = var.zones
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-datapath-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "datapath" {
  for_each       = var.zones
  subnet_id      = aws_subnet.datapath[each.key].id
  route_table_id = aws_route_table.datapath[each.key].id
}

resource "aws_route" "datapath_default" {
  for_each               = var.zones
  route_table_id         = aws_route_table.datapath[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
