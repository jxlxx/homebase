output "zone_id" {
  description = "Cloudflare zone ID used for records."
  value       = local.zone_id
}

output "record_ids" {
  description = "Map of DNS record IDs managed by this module."
  value       = { for key, record in cloudflare_record.records : key => record.id }
}
