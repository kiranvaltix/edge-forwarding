resource "valtix_policy_rule_set" "fwd_gw_ruleset" {
  name = "${var.prefix}-gw"
}

resource "valtix_policy_rules" "fwd_gw_ruleset" {
  rule_set_id = valtix_policy_rule_set.fwd_gw_ruleset.rule_set_id
  dynamic "rule" {
    for_each = local.app_certs
    content {
      name    = rule.key
      action  = "Allow Log"
      service = valtix_service_object.app[rule.key].service_id
      type    = "ReverseProxy"
    }
  }
  rule {
    name    = "egress-proxy"
    action  = "Allow Log"
    service = valtix_service_object.egress.service_id
    type    = "ReverseProxy"
  }
  rule {
    name    = "tcp-all-fwd"
    action  = "Allow Log"
    service = valtix_service_object.tcp_fwd_all.service_id
    type    = "Forwarding"
  }
}
