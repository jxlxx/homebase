terraform {
  backend "s3" {}
}

locals {
  acme_ca_servers = {
    prod    = "https://acme-v02.api.letsencrypt.org/directory"
    staging = "https://acme-staging-v02.api.letsencrypt.org/directory"
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
  user_data   = templatefile("${path.module}/cloud-init/apps-node.yaml", {
    repo_url       = var.repo_url
    repo_branch    = var.repo_branch
    acme_ca_server = local.acme_ca_servers[var.letsencrypt_environment]
  })

  dynamic "public_net" {
    for_each = var.enable_public_net ? [1] : []
    content {
      ipv4_enabled = true
      ipv6_enabled = var.enable_ipv6
    }
  }

  firewall_ids = var.firewall_ids
}
