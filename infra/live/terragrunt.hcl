locals {
  project       = "homebase"
  environment   = "prod"
  bucket_name   = "REPLACE_WITH_BUCKET_LABEL"
  bucket_region = "us-southeast-1"
  bucket_endpoint = "us-southeast-1.linodeobjects.com"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.bucket_region
    endpoint       = local.bucket_endpoint
    access_key     = get_env("LINODE_OBJ_ACCESS_KEY")
    secret_key     = get_env("LINODE_OBJ_SECRET_KEY")
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
}

inputs = {
  linode_token = get_env("LINODE_TOKEN")
}

generate "provider" {
  path      = "provider.auto.tf"
  if_exists = "overwrite"
  contents  = <<EOF2
terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.29.0"
    }
  }
}

variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

provider "linode" {
  token = var.linode_token
}
EOF2
}
