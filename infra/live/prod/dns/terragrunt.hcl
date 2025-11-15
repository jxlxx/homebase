include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/cloudflare_dns"
}

dependency "apps" {
  config_path = "../apps-node-1"
}

locals {
  zone_name = "jxlxx.org"
  subdomains = ["git", "matrix", "hedgedoc", "excalidraw", "home", "auth"]
}

inputs = {
  zone_name = local.zone_name
  records = [
    for subdomain in local.subdomains : {
      name    = subdomain
      type    = "A"
      value   = dependency.apps.outputs.ipv4
      proxied = false
    }
  ]
}
