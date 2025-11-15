output "id" {
  description = "Hetzner server ID"
  value       = hcloud_server.this.id
}

output "ipv4" {
  description = "Public IPv4 address"
  value       = hcloud_server.this.ipv4_address
}

output "ipv6" {
  description = "IPv6 network"
  value       = hcloud_server.this.ipv6_network
}
