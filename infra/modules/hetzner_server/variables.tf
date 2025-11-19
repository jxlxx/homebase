variable "name" {
  description = "Server name"
  type        = string
}

variable "server_type" {
  description = "Hetzner Cloud server type (e.g., cx21)"
  type        = string
}

variable "image" {
  description = "Image name or ID"
  type        = string
  default     = "ubuntu-24.04"
}

variable "location" {
  description = "Hetzner location (e.g., fsn1, nbg1, hel1)"
  type        = string
}

variable "ssh_keys" {
  description = "List of SSH key names or IDs already uploaded to Hetzner Cloud"
  type        = list(string)
  default     = []
}

variable "repo_url" {
  description = "Git repository URL that cloud-init should clone"
  type        = string
}

variable "repo_branch" {
  description = "Git branch to checkout"
  type        = string
  default     = "main"
}

variable "letsencrypt_environment" {
  description = "ACME environment to target (prod or staging)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "staging"], lower(var.letsencrypt_environment))
    error_message = "letsencrypt_environment must be \"prod\" or \"staging\"."
  }
}

variable "labels" {
  description = "Map of labels applied to the server"
  type        = map(string)
  default     = {}
}

variable "backups" {
  description = "Enable Hetzner automatic backups"
  type        = bool
  default     = false
}

variable "enable_public_net" {
  description = "Attach server to the public network"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPv6 on the public network"
  type        = bool
  default     = false
}

variable "firewall_ids" {
  description = "Optional list of firewall IDs to attach"
  type        = list(number)
  default     = []
}
