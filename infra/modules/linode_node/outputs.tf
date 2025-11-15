output "id" {
  description = "Linode instance ID"
  value       = linode_instance.this.id
}

output "ipv4" {
  description = "Public IPv4 address"
  value       = linode_instance.this.ip_address
}
