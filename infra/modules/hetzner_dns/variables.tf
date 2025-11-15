variable "domain" {
  description = "Root domain (e.g., jxlxx.org)"
  type        = string
}

variable "default_ttl" {
  description = "Default TTL"
  type        = number
  default     = 300
}

variable "records" {
  description = "List of DNS records"
  type = list(object({
    name  = string
    type  = string
    value = string
    ttl   = optional(number)
  }))
  default = []
}
