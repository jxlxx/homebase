terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.16.0"
    }
  }
}

provider "aws" {
  access_key                  = var.object_storage_access_key
  secret_key                  = var.object_storage_secret_key
  region                      = var.object_storage_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = var.object_storage_endpoint
  }
}

resource "aws_s3_bucket" "state" {
  bucket = var.bucket_name
  region = "hel1"
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}
