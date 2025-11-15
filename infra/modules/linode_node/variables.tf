variable "label" {
  description = "Instance label"
  type        = string
}

variable "region" {
  description = "Linode region"
  type        = string
}

variable "type" {
  description = "Linode instance type (e.g., g6-standard-2)"
  type        = string
}

variable "image" {
  description = "Image to deploy"
  type        = string
  default     = "linode/ubuntu24.04"
}

variable "ssh_keys" {
  description = "List of SSH public keys to authorize"
  type        = list(string)
  default     = []
}

variable "root_password" {
  description = "Root password Linode requires when provisioning an instance"
  type        = string
  sensitive   = true
}

variable "user_data" {
  description = "Cloud-init user data"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = list(string)
  default     = []
}

variable "backups" {
  description = "Enable Linode backups"
  type        = bool
  default     = false
}
