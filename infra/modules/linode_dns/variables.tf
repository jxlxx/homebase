variable "domain" {
  description = "Root domain (e.g., jxlxx.org)"
  type        = string
}

variable "soa_email" {
  description = "SOA contact email"
  type        = string
  default     = "admin@example.com"
}

variable "tags" {
  description = "Tags to set on the domain"
  type        = list(string)
  default     = []
}

variable "default_ttl" {
  description = "Default TTL for records"
  type        = number
  default     = 300
}

variable "records" {
  description = "DNS records to create"
  type = list(object({
    name     = string
    type     = string
    target   = string
    ttl      = optional(number)
    priority = optional(number)
  }))
  default = []
}
