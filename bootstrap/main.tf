terraform {
  required_version = ">= 1.5.0"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.29.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_object_storage_bucket" "state" {
  label   = var.bucket_label
  cluster = var.bucket_cluster
  acl     = "private"
}

resource "linode_object_storage_key" "state" {
  label = var.access_key_label
}
