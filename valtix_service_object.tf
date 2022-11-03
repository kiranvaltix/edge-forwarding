resource "valtix_service_object" "tcp_fwd_all" {
  name         = "${var.prefix}-tcp-fwd-all-nosnat"
  service_type = "Forwarding"
  protocol     = "TCP"
  source_nat   = false
  port {
    destination_ports = "1-65535"
  }
}

resource "valtix_address_object" "app_dummy" {
  name            = "${var.prefix}-dummy"
  type            = "STATIC"
  value           = ["10.0.0.1"]
  backend_address = true
}

resource "valtix_service_object" "app" {
  for_each       = local.app_certs
  name           = "${var.prefix}-proxy-${each.key}"
  service_type   = "ReverseProxy"
  protocol       = "TCP"
  transport_mode = "TLS"
  port {
    destination_ports = "443"
    backend_ports     = "443"
  }
  backend_address_group = valtix_address_object.app_dummy.address_id
  tls_profile           = valtix_profile_decryption.app[each.key].id
  sni                   = each.value.dns
}

resource "valtix_service_object" "egress" {
  name           = "${var.prefix}-proxy-egress"
  service_type   = "ReverseProxy"
  protocol       = "TCP"
  transport_mode = "TLS"
  port {
    destination_ports = "443"
    backend_ports     = "443"
  }
  backend_address_group = valtix_address_object.app_dummy.address_id
  tls_profile           = valtix_profile_decryption.root.id
}
