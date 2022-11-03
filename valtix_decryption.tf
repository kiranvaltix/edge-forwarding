locals {
  app_certs = {
    app1 : { dns : ["www.app1.com"] },
    app2 : { dns : ["www.app2.com"] },
    github : { dns : ["github.com"] },
  }
}

# create root key and certificate
resource "tls_private_key" "root" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "root" {
  private_key_pem = tls_private_key.root.private_key_pem
  allowed_uses    = ["cert_signing", "digital_signature", "crl_signing"]
  # 10 years
  validity_period_hours = 87600
  is_ca_certificate     = true
  subject {
    common_name         = "root.valtix.com"
    country             = "US"
    province            = "CA"
    locality            = "Santa Clara"
    organization        = "Valtix"
    organizational_unit = "Valtix Services"
  }
}

resource "valtix_certificate" "root" {
  name             = "${var.prefix}-root"
  certificate_type = "IMPORT_CONTENTS"
  certificate_body = tls_self_signed_cert.root.cert_pem
  private_key      = tls_private_key.root.private_key_pem
}

resource "valtix_profile_decryption" "root" {
  name             = "${var.prefix}-root"
  certificate_name = valtix_certificate.root.name
}

resource "tls_private_key" "app" {
  for_each  = local.app_certs
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "app_csr" {
  for_each        = local.app_certs
  private_key_pem = tls_private_key.app[each.key].private_key_pem
  subject {
    common_name         = "from-valtix-gateway"
    country             = "US"
    province            = "CA"
    locality            = "Santa Clara"
    organization        = "Valtix"
    organizational_unit = "Valtix Apps"
  }
  dns_names = each.value.dns
}

# create app certificate signed by the root certificate above
resource "tls_locally_signed_cert" "app" {
  for_each              = local.app_certs
  cert_request_pem      = tls_cert_request.app_csr[each.key].cert_request_pem
  ca_private_key_pem    = tls_private_key.root.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.root.cert_pem
  allowed_uses          = ["digital_signature", "key_encipherment"]
  validity_period_hours = 8760
}

resource "valtix_certificate" "app" {
  for_each         = local.app_certs
  name             = "${var.prefix}-${each.key}"
  certificate_type = "IMPORT_CONTENTS"
  certificate_body = tls_locally_signed_cert.app[each.key].cert_pem
  private_key      = tls_private_key.app[each.key].private_key_pem
}

resource "valtix_profile_decryption" "app" {
  for_each         = local.app_certs
  name             = "${var.prefix}-${each.key}"
  certificate_name = valtix_certificate.app[each.key].name
}
