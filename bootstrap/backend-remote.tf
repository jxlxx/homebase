terraform {
  backend "s3" {
    region                      = "eu-central-1"
    force_path_style            = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}
