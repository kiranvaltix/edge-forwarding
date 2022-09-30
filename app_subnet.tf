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
