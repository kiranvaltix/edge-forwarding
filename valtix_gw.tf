resource "valtix_gateway" "fwd_gw" {
  name                    = "${var.prefix}-gw"
  csp_account_name        = var.cloud_account_name
  instance_type           = "AWS_M5_LARGE"
  gateway_image           = var.gw_image
  gateway_state           = "ACTIVE"
  mode                    = "EDGE"
  security_type           = "EGRESS"
  policy_rule_set_id      = valtix_policy_rule_set.fwd_gw_ruleset.rule_set_id
  ssh_key_pair            = "vvdn"
  aws_iam_role_firewall   = var.gw_iam_role_name
  region                  = var.region
  vpc_id                  = aws_vpc.vpc.id
  mgmt_security_group     = aws_security_group.mgmt.id
  datapath_security_group = aws_security_group.datapath.id
  aws_gateway_lb          = true
  dynamic "instance_details" {
    for_each = var.zones
    content {
      availability_zone = instance_details.key
      mgmt_subnet       = aws_subnet.mgmt[instance_details.key].id
      datapath_subnet   = aws_subnet.datapath[instance_details.key].id
    }
  }
  tags = {
    prefix = var.prefix
  }
}
