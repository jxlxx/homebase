terraform {
  backend "s3" {}
}

data "cloudflare_zone" "selected" {
  name = var.zone_name
}

locals {
  zone_id     = data.cloudflare_zone.selected.id
  records_map = { for record in var.records : "${record.name}-${record.type}" => record }
}

resource "cloudflare_record" "records" {
  for_each = locals.records_map

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  value   = each.value.value
  ttl     = coalesce(try(each.value.ttl, null), var.default_ttl)
  proxied = coalesce(try(each.value.proxied, null), var.default_proxied)
}
