# Terraform provisioning script for Cloudflare DNS

# Define provider
provider "cloudflare" {
  version   = "~> 2.0"
  api_token = var.cloudflare_token
}


resource "cloudflare_zone" "zone" {
  count = var.domain != "" ? 1 : 0
  zone  = var.domain
}


resource "cloudflare_record" "common" {
  count   = var.domain != "" && (length(var.common_records) > 0) ? length(var.common_records) : 0
  zone_id = cloudflare_zone.zone[0].id
  name    = element(var.common_records[count.index], 0)
  type    = element(var.common_records[count.index], 1)
  ttl     = element(var.common_records[count.index], 2)
  proxied = element(var.common_records[count.index], 3)
  value   = element(var.common_records[count.index], 4)
}

resource "cloudflare_record" "mx" {
  count    = var.domain != "" && (length(var.mx_records) > 0) ? length(var.mx_records) : 0
  zone_id  = cloudflare_zone.zone[0].id
  name     = element(var.mx_records[count.index], 0)
  type     = "MX"
  ttl      = element(var.mx_records[count.index], 1)
  priority = element(var.mx_records[count.index], 2)
  value    = element(var.mx_records[count.index], 3)
}

resource "cloudflare_record" "srv" {
  count   = var.domain != "" && (length(var.srv_records) > 0) ? length(var.srv_records) : 0
  zone_id = cloudflare_zone.zone[0].id
  name    = "${element(var.srv_records[count.index], 0)}.${element(var.srv_records[count.index], 1)}.${var.domain}"
  type    = "SRV"
  proxied = "false"

  data = {
    service  = element(var.srv_records[count.index], 0)
    proto    = element(var.srv_records[count.index], 1)
    name     = var.domain
    priority = element(var.srv_records[count.index], 2)
    weight   = element(var.srv_records[count.index], 3)
    port     = element(var.srv_records[count.index], 4)
    target   = element(var.srv_records[count.index], 5)
  }
}

resource "cloudflare_record" "tlsa" {
  count   = var.domain != "" && (length(var.tlsa_records) > 0) ? length(var.tlsa_records) : 0
  zone_id = cloudflare_zone.zone[0].id
  name    = element(var.tlsa_records[count.index], 0)
  type    = "TLSA"
  proxied = "false"

  data = {
    usage         = element(var.tlsa_records[count.index], 1)
    selector      = element(var.tlsa_records[count.index], 2)
    matching_type = element(var.tlsa_records[count.index], 3)
    certificate   = element(var.tlsa_records[count.index], 4)
  }
}

