include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/hetzner_dns"
}

dependency "apps" {
  config_path = "../apps-node-1"
}

locals {
  domain     = "jxlxx.org"
  app_ip     = dependency.apps.outputs.ipv4
  subdomains = ["git", "matrix", "hedgedoc", "excalidraw", "home", "auth"]
}

inputs = {
  domain  = local.domain
  records = [
    for subdomain in local.subdomains : {
      name  = subdomain
      type  = "A"
      value = local.app_ip
    }
  ]
}
