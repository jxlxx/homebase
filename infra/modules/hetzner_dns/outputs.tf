output "zone_id" {
  description = "Hetzner DNS zone ID"
  value       = hetznerdns_zone.this.id
}

output "records" {
  description = "Map of record IDs"
  value       = { for key, record in hetznerdns_record.this : key => record.id }
}
