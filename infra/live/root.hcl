locals {
  project          = "homebase"
  environment      = "prod"
  bucket_name      = get_env("BUCKET_NAME")
  bucket_region    = get_env("BUCKET_REGION")
  bucket_endpoint  = get_env("BUCKET_ENDPOINT")
}

remote_state {
  backend = "s3"
  config = {
    bucket                      = local.bucket_name
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = local.bucket_region
    endpoint                    = local.bucket_endpoint
    access_key                  = get_env("OBJECT_STORAGE_ACCESS_KEY")
    secret_key                  = get_env("OBJECT_STORAGE_SECRET_KEY")
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
}

inputs = {
  hcloud_token          = get_env("HCLOUD_TOKEN")
  hetznerdns_api_token  = get_env("HETZNER_DNS_API_TOKEN")
}

generate "provider" {
  path      = "provider.auto.tf"
  if_exists = "overwrite"
  contents  = <<EOF2
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = ">= 2.2.0"
    }
  }
}

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "hetznerdns_api_token" {
  type        = string
  description = "Hetzner DNS API token"
  sensitive   = true
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  api_token = var.hetznerdns_api_token
}
EOF2
}
