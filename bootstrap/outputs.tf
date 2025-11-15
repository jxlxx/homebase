output "bucket_label" {
  description = "Object Storage bucket label"
  value       = linode_object_storage_bucket.state.label
}

output "bucket_cluster" {
  description = "Object Storage cluster"
  value       = linode_object_storage_bucket.state.cluster
}

output "bucket_endpoint" {
  description = "S3-compatible endpoint"
  value       = "${linode_object_storage_bucket.state.cluster}.linodeobjects.com"
}

output "access_key_id" {
  description = "Access key for the remote state backend"
  value       = linode_object_storage_key.state.access_key
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret key for the remote state backend"
  value       = linode_object_storage_key.state.secret_key
  sensitive   = true
}
