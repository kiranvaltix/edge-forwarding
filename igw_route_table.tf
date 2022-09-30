resource "aws_route_table" "igw" {
  depends_on = [
    valtix_gateway.fwd_gw
  ]
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-igw-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "igw" {
  route_table_id = aws_route_table.igw.id
  gateway_id     = aws_internet_gateway.igw.id
}

resource "aws_route" "to_app" {
  for_each               = var.zones
  route_table_id         = aws_route_table.igw.id
  destination_cidr_block = aws_subnet.app[each.key].cidr_block
  vpc_endpoint_id        = local.gwlbe_by_zones[each.key]
}

