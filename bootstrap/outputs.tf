output "bucket_name" {
  description = "State bucket name"
  value       = aws_s3_bucket.state.bucket
}

output "object_storage_endpoint" {
  description = "Endpoint used for Terragrunt remote state"
  value       = var.object_storage_endpoint
}

output "object_storage_region" {
  description = "Region value passed to the backend"
  value       = var.object_storage_region
}
