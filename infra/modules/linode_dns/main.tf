terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.29.0"
    }
  }
}

resource "linode_domain" "this" {
  domain   = var.domain
  type     = "master"
  soa_email = var.soa_email
  status   = "active"
  tags     = var.tags
}

locals {
  records_map = { for record in var.records : "${record.name}-${record.type}" => record }
}

resource "linode_domain_record" "this" {
  for_each  = locals.records_map
  domain_id = linode_domain.this.id
  name      = each.value.name
  type      = each.value.type
  target    = each.value.target
  ttl_sec   = coalesce(each.value.ttl, var.default_ttl)
  priority  = lookup(each.value, "priority", null)
}
