resource "valtix_policy_rule_set" "fwd_gw_ruleset" {
  name = "forwarding-gw"
}

resource "valtix_gateway" "fwd_gw" {
  name                    = "aws-forwarding-gw"
  description             = "AWS Forwarding Gateway"
  csp_account_name        = var.cloud_account_name
  instance_type           = "AWS_M5_LARGE"
  gateway_image           = "release-22.08-01"
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
  dynamic "instance_details" {
    for_each = var.zones
    content {
      availability_zone = instance_details.key
      mgmt_subnet       = aws_subnet.mgmt[instance_details.key].id
      datapath_subnet   = aws_subnet.datapath[instance_details.key].id
    }
  }
}
