terraform {
  backend "s3" {}
}

resource "hetznerdns_zone" "this" {
  name = var.domain
  ttl  = var.default_ttl
}

locals {
  records_map = { for record in var.records : "${record.name}-${record.type}" => record }
}

resource "hetznerdns_record" "this" {
  for_each = locals.records_map

  zone_id = hetznerdns_zone.this.id
  name    = each.value.name
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", var.default_ttl)
  value   = each.value.value
}
