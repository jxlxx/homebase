variable "zone_name" {
  type        = string
  description = "DNS zone name managed in Cloudflare (e.g., jxlxx.org)."
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID (required because provider v5 no longer allows lookups by name)."
}

variable "records" {
  description = "List of DNS records to manage in Cloudflare."
  type = list(object({
    name    = string
    type    = string
    value   = string
    ttl     = optional(number)
    proxied = optional(bool)
  }))
  default = []
}

variable "default_ttl" {
  type        = number
  description = "Default TTL to use when not specified on a per-record basis."
  default     = 300
}

variable "default_proxied" {
  type        = bool
  description = "Default proxied flag to use when not specified on the record."
  default     = false
}
