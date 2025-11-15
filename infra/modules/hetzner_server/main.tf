terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
  }
}

resource "hcloud_server" "this" {
  name        = var.name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  backups     = var.backups
  labels      = var.labels
  ssh_keys    = var.ssh_keys
  user_data   = var.user_data

  dynamic "public_net" {
    for_each = var.enable_public_net ? [1] : []
    content {
      ipv4_enabled = true
      ipv6_enabled = var.enable_ipv6
    }
  }

  firewall_ids = var.firewall_ids
}
