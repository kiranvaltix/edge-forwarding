locals {
  gwlbe_by_zones = { for gwlbe in valtix_gateway.fwd_gw.gateway_gwlb_endpoints : gwlbe.availability_zone => gwlbe.endpoint_id }
}

resource "aws_route_table" "app_via_valtix" {
  depends_on = [
    valtix_gateway.fwd_gw
  ]
  for_each = var.zones
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name   = "${var.prefix}-app-via-valtix-${each.key}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "app_via_valtix" {
  for_each       = var.zones
  subnet_id      = aws_subnet.app[each.key].id
  route_table_id = aws_route_table.app_via_valtix[each.key].id
}

resource "aws_route" "app_default_via_valtix" {
  for_each               = var.zones
  route_table_id         = aws_route_table.app_via_valtix[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = local.gwlbe_by_zones[each.key]
}
