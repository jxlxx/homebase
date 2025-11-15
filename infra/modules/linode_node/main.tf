terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.29.0"
    }
  }
}

resource "linode_instance" "this" {
  label           = var.label
  region          = var.region
  type            = var.type
  image           = var.image
  private_ip      = true
  backups_enabled = var.backups
  tags            = var.tags

  authorized_keys = var.ssh_keys
  root_pass       = var.root_password
  user_data       = var.user_data
}
