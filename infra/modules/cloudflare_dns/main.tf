terraform {
  backend "s3" {}
}

locals {
  zone_id     = var.zone_id
  records_map = { for record in var.records : "${record.name}-${record.type}" => record }
}

resource "cloudflare_dns_record" "records" {
  for_each = local.records_map

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = coalesce(try(each.value.ttl, null), var.default_ttl)
  proxied = coalesce(try(each.value.proxied, null), var.default_proxied)
}
