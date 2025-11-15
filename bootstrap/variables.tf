variable "object_storage_access_key" {
  description = "Access key for Hetzner Object Storage (manually created)"
  type        = string
  sensitive   = true
}

variable "object_storage_secret_key" {
  description = "Secret key for Hetzner Object Storage"
  type        = string
  sensitive   = true
}

variable "object_storage_endpoint" {
  description = "S3 endpoint, e.g., https://fsn1.your-object-storage-endpoint"
  type        = string
}

variable "object_storage_region" {
  description = "Region required by the AWS provider (can match the endpoint region)"
  type        = string
  default     = "eu-central"
}

variable "bucket_name" {
  description = "Unique bucket name for Terraform state"
  type        = string
}
