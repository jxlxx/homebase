include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/linode_dns"
}

dependency "apps" {
  config_path = "../apps-node-1"
}

locals {
  domain     = "jxlxx.org"
  app_ip     = dependency.apps.outputs.ipv4
  subdomains = ["git", "matrix", "hedgedoc", "excalidraw", "home"]
}

inputs = {
  domain    = local.domain
  soa_email = "hostmaster@${local.domain}"
  tags      = ["homebase", "prod"]
  records   = concat(
    [for subdomain in local.subdomains : {
      name   = subdomain
      type   = "A"
      target = local.app_ip
    }],
    [{
      name   = "auth"
      type   = "A"
      target = local.app_ip
    }]
  )
}
