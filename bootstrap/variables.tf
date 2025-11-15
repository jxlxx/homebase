variable "linode_token" {
  description = "Personal access token with Object Storage and Domains permissions"
  type        = string
  sensitive   = true
}

variable "bucket_label" {
  description = "Unique label for the Terraform state bucket"
  type        = string
  default     = "homebase-terraform-state"
}

variable "bucket_cluster" {
  description = "Object Storage cluster (e.g., us-southeast-1)"
  type        = string
  default     = "us-southeast-1"
}

variable "access_key_label" {
  description = "Label for the generated Object Storage access key"
  type        = string
  default     = "homebase-terraform"
}
