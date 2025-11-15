output "domain_id" {
  description = "Linode domain ID"
  value       = linode_domain.this.id
}

output "records" {
  description = "IDs of DNS records"
  value       = { for key, record in linode_domain_record.this : key => record.id }
}
